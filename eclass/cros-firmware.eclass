# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
#
# Original Author: The Chromium OS Authors <chromium-os-dev@chromium.org>
# Purpose: Generate shell script containing firmware update bundle.
#

# TODO(hungte) Remove cros-binary when BCS_OVERLAY transition is ready.
inherit cros-workon cros-binary

# @ECLASS-VARIABLE: CROS_FIRMWARE_BCS_OVERLAY
# @DESCRIPTION: (Optional) Name of board overlay on Binary Component Server
: ${CROS_FIRMWARE_BCS_OVERLAY:=${BOARD_OVERLAY##*/}}

# TODO(hungte) Remove when BCS_OVERLAY transition is ready.
# @ECLASS-VARIABLE: CROS_FIRMWARE_BCS_USER_NAME
# @DESCRIPTION: (Optional) Name of user on BCS server
: ${CROS_FIRMWARE_BCS_USER_NAME:=}

# TODO(hungte) Remove when BCS_OVERLAY transition is ready.
# @ECLASS-VARIABLE: CROS_FIRMWARE_BCS_OVERLAY_NAME
# @DESCRIPTION: (Optional) Name of the ebuild overlay.
: ${CROS_FIRMWARE_BCS_OVERLAY_NAME:=}

# @ECLASS-VARIABLE: CROS_FIRMWARE_MAIN_IMAGE
# @DESCRIPTION: (Optional) Location of system firmware (BIOS) image
: ${CROS_FIRMWARE_MAIN_IMAGE:=}

# @ECLASS-VARIABLE: CROS_FIRMWARE_MAIN_RW_IMAGE
# @DESCRIPTION: (Optional) Location of RW system firmware image
: ${CROS_FIRMWARE_MAIN_RW_IMAGE:=}

# @ECLASS-VARIABLE: CROS_FIRMWARE_EC_IMAGE
# @DESCRIPTION: (Optional) Location of EC firmware image
: ${CROS_FIRMWARE_EC_IMAGE:=}

# @ECLASS-VARIABLE: CROS_FIRMWARE_EC_VERSION
# @DESCRIPTION: (Optional) Version name of EC firmware
: ${CROS_FIRMWARE_EC_VERSION:=}

# TODO(hungte) Remove when BCS_OVERLAY transition is ready.
# @ECLASS-VARIABLE: CROS_FIRMWARE_MAIN_SUM
# @DESCRIPTION: (Optional) SHA-1 checksum of system firmware (BIOS) image
: ${CROS_FIRMWARE_MAIN_SUM:=}

# TODO(hungte) Remove when BCS_OVERLAY transition is ready.
# @ECLASS-VARIABLE: CROS_FIRMWARE_MAIN_RW_SUM
# @DESCRIPTION: (Optional) SHA-1 checksum of RW system firmware image
: ${CROS_FIRMWARE_MAIN_RW_SUM:=}

# TODO(hungte) Remove when BCS_OVERLAY transition is ready.
# @ECLASS-VARIABLE: CROS_FIRMWARE_EC_SUM
# @DESCRIPTION: (Optional) SHA-1 checksum of EC firmware image on BCS
: ${CROS_FIRMWARE_EC_SUM:=}

# @ECLASS-VARIABLE: CROS_FIRMWARE_PLATFORM
# @DESCRIPTION: (Optional) Platform name of firmware
: ${CROS_FIRMWARE_PLATFORM:=}

# @ECLASS-VARIABLE: CROS_FIRMWARE_SCRIPT
# @DESCRIPTION: (Optional) Entry script file name of updater
: ${CROS_FIRMWARE_SCRIPT:=}

# @ECLASS-VARIABLE: CROS_FIRMWARE_UNSTABLE
# @DESCRIPTION: (Optional) Mark firmware as unstable (always RO+RW update)
: ${CROS_FIRMWARE_UNSTABLE:=}

# @ECLASS-VARIABLE: CROS_FIRMWARE_BINARY
# @DESCRIPTION: (Optional) location of custom flashrom tool
: ${CROS_FIRMWARE_FLASHROM_BINARY:=}

# @ECLASS-VARIABLE: CROS_FIRMWARE_EXTRA_LIST
# @DESCRIPTION: (Optional) Semi-colon separated list of additional resources
: ${CROS_FIRMWARE_EXTRA_LIST:=}

# @ECLASS-VARIABLE: CROS_FIRMWARE_FORCE_UPDATE
# @DESCRIPTION: (Optional) Always add "force update firmware" tag.
: ${CROS_FIRMWARE_FORCE_UPDATE:=}

# Check for EAPI 2+
case "${EAPI:-0}" in
	4|3|2) ;;
	*) die "unsupported EAPI" ;;
esac

# $board-overlay/make.conf may contain these flags to always create "firmware
# from source".
IUSE="bootimage cros_ec"

# Some tools (flashrom, iotools, mosys, ...) were bundled in the updater so we
# don't write RDEPEND=$DEPEND. RDEPEND should have an explicit list of what it
# needs to extract and execute the updater.
DEPEND="
	>=chromeos-base/vboot_reference-1.0-r230
	chromeos-base/vpd
	dev-util/shflags
	>=sys-apps/flashrom-0.9.3-r36
	sys-apps/mosys
	"

# Build firmware from source.
DEPEND="$DEPEND
	bootimage? ( sys-boot/chromeos-bootimage )
	cros_ec? ( chromeos-base/chromeos-ec )
	"

# Maintenance note:  The factory install shim downloads and executes
# the firmware updater.  Consequently, runtime dependencies for the
# updater are also runtime dependencies for the install shim.
#
# The contents of RDEPEND below must also be present in the
# chromeos-base/chromeos-factoryinstall ebuild in PROVIDED_DEPEND.
# If you make any change to the list below, you may need to make a
# matching change in the factory install ebuild.
#
# TODO(hungte) remove gzip/tar if we have busybox
RDEPEND="
	app-arch/gzip
	app-arch/sharutils
	app-arch/tar
	chromeos-base/vboot_reference
	sys-apps/util-linux"

RESTRICT="mirror"

# Local variables.

UPDATE_SCRIPT="chromeos-firmwareupdate"
FW_IMAGE_LOCATION=""
FW_RW_IMAGE_LOCATION=""
EC_IMAGE_LOCATION=""
EXTRA_LOCATIONS=()
RETURN_VALUE=""

# TODO(hungte) Remove when BCS_OVERLAY transition is ready.
# Returns true (0) if parameter starts with "bcs://"
_is_on_bcs() {
	[[ "${1%%://*}" = "bcs" ]]
}

# TODO(hungte) Remove when BCS_OVERLAY transition is ready.
# Returns true (0) if parameter starts with "file://"
_is_in_files() {
	[[ "${1%%://*}" = "file" ]]
}

# Fetch a file from the Binary Component Server
# Parameters: URI of file "bcs://filename.tbz2", checksum of file.
# Returns: Nothing
_bcs_fetch() {
	${CROS_BINARY_FETCH_REQUIRED} || return 0
	local filename="${1##*://}"
	local checksum="$2"

	local bcs_host="git.chromium.org:6222"
	local bcs_user="${CROS_FIRMWARE_BCS_USER_NAME}"
	local bcs_pkgdir="${CATEGORY}/${PN}"
	local bcs_root="$CROS_FIRMWARE_BCS_OVERLAY_NAME"

	# Support both old and new locations for BCS binaries.
	# TODO(dparker@chromium.org): Remove after all binaries are using the
	# new location. crosbug.com/22789
	[ -z "$bcs_root" ] && bcs_root="home/$CROS_FIRMWARE_BCS_USER_NAME"

	URI_BASE="ssh://$bcs_user@$bcs_host/$bcs_root/$bcs_pkgdir"
	CROS_BINARY_URI="${URI_BASE}/${filename}"
	CROS_BINARY_SUM="${checksum}"
	cros-binary_fetch
}

# TODO(hungte) Remove when BCS_OVERLAY transition is ready.
# Unpack a tbz2 firmware archive to ${S}
# Parameters: Location of archived firmware
# Returns: Location of unpacked firmware as $RETURN_VALUE
_src_unpack() {
	local filepath="${1}"
	local filename="$(basename ${filepath})"
	mkdir -p "${S}" || die "Not able to create ${S}"
	cp "${filepath}" "${S}" || die "Can't copy ${filepath} to ${S}"
	cd "${S}" || die "Can't change directory to ${S}"
	tar -axpf "${filename}" ||
	  die "Failed to unpack ${filename}"
	local contents="$(tar -atf "${filename}")"
	if [ "$(echo "$contents" | wc -l)" -gt 1 ]; then
		# Currently we can only serve one file (or directory).
		ewarn "WARNING: package $filename contains multiple files."
		contents="$(echo "$contents" | head -n 1)"
	fi
	RETURN_VALUE="${S}/$contents"
}

# TODO(hungte) Remove when BCS_OVERLAY transition is ready.
# Unpack a tbz2 archive fetched from the BCS to ${S}
# Parameters: URI of file. Example: "bcs://filename.tbz2"
# Returns: Location of unpacked firmware as $RETURN_VALUE
_bcs_src_unpack() {
	local filename="${1##*://}"
	if ${CROS_BINARY_FETCH_REQUIRED}; then
		_src_unpack "${CROS_BINARY_STORE_DIR}/${filename}"
	else
		_src_unpack "${DISTDIR}/${filename}"
	fi
	RETURN_VALUE="${RETURN_VALUE}"
}

# TODO(hungte) Remove when BCS_OVERLAY transition is ready.
# Provides the location of a firmware image given a URI.
# Unpacks the firmware image if necessary.
# Parameters: URI of file.
#   Example: "file://filename.ext" or an absolute filepath.
# Returns the absolute filepath of the unpacked firmware as $RETURN_VALUE
_firmware_image_location() {
	local source_uri=$1
	if _is_in_files "${source_uri}"; then
		local image_location="${FILESDIR}/${source_uri#*://}"
	else
		local image_location="${source_uri}"
	fi
	[[ -f "${image_location}"  ]] || die "File not found: ${image_location}"
	case "${image_location}" in
		*.tbz2 | *.tbz | *.tar.bz2 | *.tgz | *.tar.gz )
			_src_unpack "${image_location}"
			RETURN_VALUE="${RETURN_VALUE}"
			;;
		* )
			RETURN_VALUE="${image_location}"
	esac
}

# New SRC_URI based approach.

# TODO(hungte) Replace RETURN_VALUE hack by $(_add_source $url).
_add_source() {
	local protocol="${1%%://*}"
	local uri="${1#*://}"
	local overlay="${CROS_FIRMWARE_BCS_OVERLAY#overlay-}"
	local user="bcs-${overlay#variant-*-}"
	local bcs_url="gs://chromeos-binaries/HOME/${user}/overlay-${overlay}"

	case "${protocol}" in
		bcs)
			SRC_URI+=" ${bcs_url}/${CATEGORY}/${PN}/${uri}"
			RETURN_VALUE="${DISTDIR}/${uri##*/}"
			;;
		http|https)
			SRC_URI+=" $1"
			RETURN_VALUE="${DISTDIR}/${1##*/}"
			;;
		file)
			RETURN_VALUE="${uri}"
			;;
		*)
			RETURN_VALUE="$1"
			;;
	esac
}

# TODO(hungte) Replace RETURN_VALUE hack by $(_unpack_archive $url).
_unpack_archive() {
	local input="$1"
	local archive="${input##*/}"
	local folder="${S}/.dist/${archive}"
	# "unpack" defaults to ${DISTDIR}, so for files already downloaded into
	# ${DISTDIR} (ex, bcs://, http://, or other things in SRC_URI), strip
	# the ${DISTDIR} prefix. For any other files (ex, ${FILESDIR}/file), use
	# the complete ${input} path.
	local unpack_name="${input#${DISTDIR}/}"

	case "${input##*.}" in
		tar|tbz2|tbz|bz|gz|tgz|zip|xz) ;;
		*)
			RETURN_VALUE="${input}"
			return
			;;
	esac

	mkdir -p "${folder}" || die "Not able to create ${folder}"
	(cd "${folder}" && unpack "${unpack_name}") ||
		die "Failed to unpack ${unpack_name}."
	local contents=($(ls "${folder}"))
	if [[ ${#contents[@]} -gt 1 ]]; then
		# Currently we can only serve one file (or directory).
		ewarn "WARNING: package ${input} contains multiple files."
	fi
	RETURN_VALUE="${folder}/${contents}"
}

_legacy_src_unpack() {
	# Fetch and unpack the system firmware image
	if [[ -n "${CROS_FIRMWARE_MAIN_IMAGE}" ]]; then
		if _is_on_bcs "${CROS_FIRMWARE_MAIN_IMAGE}"; then
			_bcs_fetch "${CROS_FIRMWARE_MAIN_IMAGE}" \
				   "${CROS_FIRMWARE_MAIN_SUM}"
			_bcs_src_unpack "${CROS_FIRMWARE_MAIN_IMAGE}"
			FW_IMAGE_LOCATION="${RETURN_VALUE}"
		else
			_firmware_image_location "${CROS_FIRMWARE_MAIN_IMAGE}"
			FW_IMAGE_LOCATION="${RETURN_VALUE}"
		fi
	fi

	# Fetch and unpack the system RW firmware image
	if [[ -n "${CROS_FIRMWARE_MAIN_RW_IMAGE}" ]]; then
		if _is_on_bcs "${CROS_FIRMWARE_MAIN_RW_IMAGE}"; then
			_bcs_fetch "${CROS_FIRMWARE_MAIN_RW_IMAGE}" \
				   "${CROS_FIRMWARE_MAIN_RW_SUM}"
			_bcs_src_unpack "${CROS_FIRMWARE_MAIN_RW_IMAGE}"
			FW_RW_IMAGE_LOCATION="${RETURN_VALUE}"
		else
			_firmware_image_location "${CROS_FIRMWARE_MAIN_RW_IMAGE}"
			FW_RW_IMAGE_LOCATION="${RETURN_VALUE}"
		fi
	fi

	# Fetch and unpack the EC image
	if [[ -n "${CROS_FIRMWARE_EC_IMAGE}" ]]; then
		if _is_on_bcs "${CROS_FIRMWARE_EC_IMAGE}"; then
			_bcs_fetch "${CROS_FIRMWARE_EC_IMAGE}"\
				   "${CROS_FIRMWARE_EC_SUM}"
			_bcs_src_unpack "${CROS_FIRMWARE_EC_IMAGE}"
			EC_IMAGE_LOCATION="${RETURN_VALUE}"
		else
			_firmware_image_location "${CROS_FIRMWARE_EC_IMAGE}"
			EC_IMAGE_LOCATION="${RETURN_VALUE}"
		fi
	fi

	# Fetch and unpack BCS resources in CROS_FIRMWARE_EXTRA_LIST
	local extra extra_list
	# For backward compatibility, colon is still supported when there is no
	# special URL (bcs://, file://).
	local tr_source=';:' tr_target='\n\n'
	if echo "${CROS_FIRMWARE_EXTRA_LIST}" | grep -q '://'; then
		tr_source=';'
		tr_target='\n'
	fi
	extra_list="$(echo "${CROS_FIRMWARE_EXTRA_LIST}" |
			tr "$tr_source" "$tr_target")"
	EXTRA_LOCATIONS=()
	for extra in ${extra_list}; do
		if _is_on_bcs "${extra}"; then
			_bcs_fetch "${extra}" ""
			_bcs_src_unpack "${extra}"
			RETURN_VALUE="${RETURN_VALUE}"
		else
			RETURN_VALUE="${extra}"
		fi
		EXTRA_LOCATIONS+=(${RETURN_VALUE})
	done
}

cros-firmware_src_unpack() {
	cros-workon_src_unpack

	if [[ -n "${CROS_FIRMWARE_BCS_OVERLAY_NAME}" ]]; then
		_legacy_src_unpack
		return
	fi

	_unpack_archive "${FW_IMAGE_LOCATION}"
	FW_IMAGE_LOCATION="${RETURN_VALUE}"
	_unpack_archive "${FW_RW_IMAGE_LOCATION}"
	FW_RW_IMAGE_LOCATION="${RETURN_VALUE}"
	_unpack_archive "${EC_IMAGE_LOCATION}"
	EC_IMAGE_LOCATION="${RETURN_VALUE}"

	local extra
	local extra_list=()
	for extra in "${EXTRA_LOCATIONS[@]}"; do
		_unpack_archive "${extra}"
		extra_list+=(${RETURN_VALUE})
	done
	EXTRA_LOCATIONS=("${extra_list[@]}")
}

_add_param() {
	local prefix="$1"
	local value="$2"

	if [[ -n "$value" ]]; then
		echo "$prefix '$value' "
	fi
}

_add_bool_param() {
	local prefix="$1"
	local value="$2"

	if [[ -n "$value" ]]; then
		echo "$prefix "
	fi
}

cros-firmware_src_compile() {
	local image_cmd="" ext_cmd="" local_image_cmd=""
	local root="${ROOT%/}"

	# Prepare images
	image_cmd+="$(_add_param -b "${FW_IMAGE_LOCATION}")"
	image_cmd+="$(_add_param -e "${EC_IMAGE_LOCATION}")"
	image_cmd+="$(_add_param -w "${FW_RW_IMAGE_LOCATION}")"
	image_cmd+="$(_add_param --ec_version "${CROS_FIRMWARE_EC_VERSION}")"

	# Prepare extra commands
	ext_cmd+="$(_add_bool_param --unstable "${CROS_FIRMWARE_UNSTABLE}")"
	ext_cmd+="$(_add_param --extra "$(IFS=:; echo "${EXTRA_LOCATIONS[*]}")")"
	ext_cmd+="$(_add_param --script "${CROS_FIRMWARE_SCRIPT}")"
	ext_cmd+="$(_add_param --platform "${CROS_FIRMWARE_PLATFORM}")"
	ext_cmd+="$(_add_param --flashrom "${CROS_FIRMWARE_FLASHROM_BINARY}")"
	ext_cmd+="$(_add_param --tool_base \
	            "$root/firmware/utils:$root/usr/sbin:$root/usr/bin")"

	# Pack firmware update script!
	if [ -z "$image_cmd" ]; then
		# Create an empty update script for the generic case
		# (no need to update)
		einfo "Building empty firmware update script"
		echo -n > ${UPDATE_SCRIPT}
	else
		# create a new script
		einfo "Build ${BOARD_USE} firmware updater: $image_cmd $ext_cmd"
		./pack_firmware.sh $image_cmd $ext_cmd -o $UPDATE_SCRIPT ||
		die "Cannot pack firmware."
	fi

	# Create local updaters
	local local_image_cmd="" output_bom output_file
	if use cros_ec; then
		local_image_cmd+="-e $root/firmware/ec.bin "
	fi
	if use bootimage; then
		for fw_file in $root/firmware/image-*.bin; do
			einfo "Updater for local fw - $fw_file"
			output_bom=${fw_file##*/image-}
			output_bom=${output_bom%%.bin}
			output_file=updater-$output_bom.sh
			./pack_firmware.sh -b $fw_file -o $output_file \
				$local_image_cmd $ext_cmd ||
				die "Cannot pack local firmware."
		done
	elif use cros_ec; then
		# TODO(hungte) Deal with a platform that has only EC and no
		# BIOS, which is usually incorrect configuration.
		die "Sorry, platform without local BIOS EC is not supported."
	fi
}

cros-firmware_src_install() {
	# install the main updater program
	dosbin $UPDATE_SCRIPT || die "Failed to install update script."

	# install factory wipe script
	dosbin firmware-factory-wipe

	# install updaters for firmware-from-source archive.
	if use bootimage; then
		exeinto /firmware
		doexe updater-*.sh
	fi

	# The "force_update_firmware" tag file is used by chromeos-installer.
	if [ -n "$CROS_FIRMWARE_FORCE_UPDATE" ]; then
		insinto /root
		touch .force_update_firmware
		doins .force_update_firmware
	fi
}

cros-firmware_setup_source() {
	_add_source "${CROS_FIRMWARE_MAIN_IMAGE}"
	FW_IMAGE_LOCATION="${RETURN_VALUE}"
	_add_source "${CROS_FIRMWARE_MAIN_RW_IMAGE}"
	FW_RW_IMAGE_LOCATION="${RETURN_VALUE}"
	_add_source "${CROS_FIRMWARE_EC_IMAGE}"
	EC_IMAGE_LOCATION="${RETURN_VALUE}"

	local backup_IFS="${IFS}"
	IFS=';'
	local extra_list=(${CROS_FIRMWARE_EXTRA_LIST})
	IFS="${backup_IFS}"
	EXTRA_LOCATIONS=()
	for extra in "${extra_list[@]}"; do
		_add_source "${extra}"
		EXTRA_LOCATIONS+=(${RETURN_VALUE})
	done
}

# If "inherit cros-firmware" appears at end of ebuild file, build source URI
# automatically. Otherwise, you have to put an explicit call to
# "cros-firmware_setup_source" at end of ebuild file.
[[ -n "${CROS_FIRMWARE_MAIN_IMAGE}" ]] && cros-firmware_setup_source

EXPORT_FUNCTIONS src_unpack src_compile src_install
