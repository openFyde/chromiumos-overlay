# Copyright (C) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

# A note about this ebuild: this ebuild is Unified Build enabled but
# not in the way in which most other ebuilds with Unified Build
# knowledge are: the primary use for this ebuild is for engineer-local
# work or firmware builder work. In both cases, the build might be
# happening on a branch in which only one of many of the models are
# available to build. The logic in this ebuild succeeds so long as one
# of the many models successfully builds.

EAPI="5"

CROS_WORKON_COMMIT=("9df107fb56edbdbbeb39905ddd488244a25ee4e9" "46ff940bfe5066b1531065c158d70ee38ecdf4eb" "e05bfa91102dd5137b4027b4f3405e041ffe2c32")
CROS_WORKON_TREE=("6d56729183f5693e0fff9ca11f9fa25755030cf9" "cd80c1bf88b62c63e5f0b7c754801b294c46fb9f" "1f42f6d549ba7b3f6bc5d67029984b113787ae0d")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/ec"
	"chromiumos/third_party/tpm2"
	"chromiumos/third_party/cryptoc"
)
CROS_WORKON_LOCALNAME=(
	"ec"
	"../third_party/tpm2"
	"../third_party/cryptoc"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/ec"
	"${S}/third_party/tpm2"
	"${S}/third_party/cryptoc"
)

inherit toolchain-funcs cros-ec-board cros-workon cros-unibuild coreboot-sdk

DESCRIPTION="Embedded Controller firmware code"
HOMEPAGE="https://www.chromium.org/chromium-os/ec-development"
MIRROR_PATH="gs://chromeos-localmirror/distfiles/"
CR50_ROS=(cr50.prod.ro.A.0.0.10 cr50.prod.ro.B.0.0.10)
SRC_URI="${CR50_ROS[@]/#/${MIRROR_PATH}}"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="quiet verbose coreboot-sdk unibuild fuzzer bootblock_in_ec asan msan ubsan test"

RDEPEND="
	fuzzer? (
		dev-libs/openssl:=
		dev-libs/protobuf:=
	)
	test? (
		dev-libs/openssl:=
		dev-libs/protobuf:=
	)
"

# EC build requires libftdi, but not used for runtime (b:129129436)
DEPEND="
	${RDEPEND}
	dev-embedded/libftdi:1=
	fuzzer? ( dev-libs/libprotobuf-mutator:= )
	test? ( dev-libs/libprotobuf-mutator:= )
	virtual/chromeos-ec-private-files
	virtual/chromeos-ec-touch-firmware
	unibuild? ( chromeos-base/chromeos-config )
	bootblock_in_ec? ( sys-boot/coreboot )
"

# We don't want binchecks since we're cross-compiling firmware images using
# non-standard layout.
RESTRICT="binchecks"

# Cr50 signer manifest converted into proper json format.
CR50_JSON='prod.json'

src_unpack() {
	cros-workon_src_unpack
	S+="/platform/ec"
}

src_prepare() {
	if ! [[ ${PV} == 9999* ]]; then
		# Link the private sources in the private/ sub-directory if needed
		ln -sf ${SYSROOT}/firmware/ec-private ${S}/private
	fi
}

src_configure() {
	cros-workon_src_configure
}

set_build_env() {
	if ! use coreboot-sdk; then
		export CROSS_COMPILE_arm=arm-none-eabi-
		export CROSS_COMPILE_i386=i686-pc-linux-gnu-
	else
		export CROSS_COMPILE_arm=${COREBOOT_SDK_PREFIX_arm}
		export CROSS_COMPILE_i386=${COREBOOT_SDK_PREFIX_x86_32}
	fi

	export CROSS_COMPILE_coreboot_sdk_arm=${COREBOOT_SDK_PREFIX_arm}
	export CROSS_COMPILE_coreboot_sdk_i386=${COREBOOT_SDK_PREFIX_x86_32}

	# nds32 always uses coreboot-sdk
	export CROSS_COMPILE_nds32=${COREBOOT_SDK_PREFIX_nds32}

	tc-export CC BUILD_CC
	export HOSTCC=${CC}
	export BUILDCC=${BUILD_CC}

	get_ec_boards

	EC_OPTS=()
	use quiet && EC_OPTS+=( -s V=0 )
	use verbose && EC_OPTS+=( V=1 )
}

# Build EC with a supplied configuration and output directory.
#   $1: Board name.
#   $2: Build directory to use (e.g. "build_serial").
#   $3: Path to touchpad firmware to be packed (optional).
#   $4: Path to bootblock to be packed (optional).
make_ec() {
	local board="$1"
	local build_dir="$2"
	local touchpad_fw="$3"
	local bootblock="$4"
	local extra_opts=()

	einfo "Building EC for ${board} into ${build_dir} with" \
		"touchpad_fw=${touchpad_fw} bootblock=${bootblock}"

	if [[ -n "${touchpad_fw}" ]]; then
		extra_opts+=( TOUCHPAD_FW="${touchpad_fw}" )
	fi
	if [[ -n "${bootblock}" ]]; then
		extra_opts+=( BOOTBLOCK="${bootblock}" )
	fi

	BOARD=${target} emake "${EC_OPTS[@]}" clean
	BOARD=${target} emake "${EC_OPTS[@]}" "${extra_opts[@]}" all
	# Since the ec codebase does not allow specifying a target build
	# directory, move its build directory to the requested location.
	rm -rf "${build_dir}"
	mv build "${build_dir}"
}

#
# Convert internal representation of the signer manifest into conventional
# json.
#
prepare_cr50_signer_aid () {
	local signer_manifest="util/signer/ec_RW-manifest-prod.json"
	local codesigner="cr50-codesigner"

	elog "Converting prod manifest into json format"

	if ! type -P "${codesigner}" >/dev/null; then
		ewarn "${codesigner} not available, not preparing ${CR50_JSON}"
		return
	fi

	"${codesigner}" --convert-json -i "${signer_manifest}" \
			-o "${S}/${CR50_JSON}" || \
		die "failed to convert signer manifest ${signer_manifest}"
}

src_compile() {
	set_build_env

	local target
	einfo "Building targets: ${EC_BOARDS[@]}"
	for target in "${EC_BOARDS[@]}"; do
		# Always pass TOUCHPAD_FW parameter: boards that do not require
		# it will simply ignore the parameter, even if the touchpad FW
		# file does not exist.  Note that touchpad firmware lives in
		# the ${target} subdirectory regardless of whether or not unibuild
		# is enabled.
		local touchpad_fw="${SYSROOT}/firmware/${target}/touchpad.bin"

		# In certain devices, the only root-of-trust available is EC-RO.
		# Thus the AP bootblock needs to be installed in this write-protected
		# area, and supplied to AP on boot.  See b:110907438 for details.
		local bootblock
		local bootblock_serial
		local target_root
		if use unibuild; then
			target_root="${SYSROOT}/firmware/${target}"
		else
			target_root="${SYSROOT}/firmware"
		fi

		if use bootblock_in_ec; then
			local bootblock="${target_root}/coreboot/bootblock.bin"
			local bootblock_serial="${target_root}/coreboot_serial/bootblock.bin"

			if [[ -f "$bootblock_serial" ]]; then
				# Since we are including AP bootblock, two sets
				# of EC images need to be built -- one with
				# serial console enabled, and one without.
				make_ec "${target}" \
					"${WORKDIR}/build_${target}_serial" \
					"${touchpad_fw}" "${bootblock_serial}"
			fi
		fi
		make_ec "${target}" "${WORKDIR}/build_${target}" \
			"${touchpad_fw}" "${bootblock}"

		if [[ "${target}" == "cr50" ]]; then
			prepare_cr50_signer_aid
		fi
	done

	if use fuzzer ; then
		local sanitizers=()
		use asan && sanitizers+=( TEST_ASAN=y )
		use msan && sanitizers+=( TEST_MSAN=y )
		use ubsan && sanitizers+=( TEST_UBSAN=y )
		emake buildfuzztests "${sanitizers[@]}"
	fi
}

#
# Install additional files, necessary for Cr50 signer inputs.
#
# param $1 - the output directory to install the files.
#
install_cr50_signer_aid () {
	local dest_dir="${1}"

	if [[ ! -f ${S}/${CR50_JSON} ]]; then
		ewarn "Not installing Cr50 support files"
		return
	fi

	elog "Installing Cr50 signer support files"

	insinto "${dest_dir}"

	newins "${DISTDIR}/cr50.prod.ro.A.0.0.10" "prod.ro.A"
	newins "${DISTDIR}/cr50.prod.ro.B.0.0.10" "prod.ro.B"
	doins "${S}/board/cr50/rma_key_blob".*.{prod,test}
	doins "${S}/${CR50_JSON}"
	doins "${S}/util/signer/fuses.xml"
}

#
# Install firmware binaries for a specific board.
#
# param $1 - the board name.
# param $2 - the build directory.
# param $3 - the output directory to install artifacts.
# param $4 - the suffix to be used for installed artifacts (optional).
#            e.g. if suffix="serial", ec.bin => ec.serial.bin
#
board_install() {
	local board="$1"
	local build_dir="$2"
	local dest_dir="$3"
	local suffix="$4"
	local file_suffix
	local ecrw

	einfo "Installing EC for ${board} from ${build_dir} into ${dest_dir}" \
		"(suffix=${suffix})"

	if [[ -n "${suffix}" ]]; then
		file_suffix=".${suffix}"
	fi

	insinto "${dest_dir}"
	pushd "${build_dir}/${target}" >/dev/null || die

	openssl dgst -sha256 -binary RO/ec.RO.flat > RO/ec.RO.hash
	newins ec.bin "ec${file_suffix}.bin"
	newins ec.obj "ec${file_suffix}.obj"
	if grep -q '^CONFIG_VBOOT_EFS=y' .config; then
		# This extracts EC_RW.bin (= RW_A region image) from ec.bin.
		futility sign --type rwsig ec.bin || die
		ecrw="EC_RW.bin"
	else
		ecrw="RW/ec.RW.flat"
	fi
	newins "${ecrw}" "ec${file_suffix}.RW.bin"
	openssl dgst -sha256 -binary "${ecrw}" > RW/ec.RW.hash
	newins RW/ec.RW.hash "ec${file_suffix}.RW.hash"
	# Intermediate file for debugging.
	newins RW/ec.RW.elf "ec${file_suffix}.RW.elf"

	# Install RW_B files except for RWSIG, which uses the same files as RW_A
	if grep -q '^CONFIG_RW_B=y' .config && \
			! grep -q '^CONFIG_RWSIG_TYPE_RWSIG=y' .config; then
		openssl dgst -sha256 -binary RW/ec.RW_B.flat > RW/ec.RW_B.hash
		newins RW/ec.RW_B.flat "ec${file_suffix}.RW_B.bin"
		newins RW/ec.RW_B.hash "ec${file_suffix}.RW_B.hash"
		# Intermediate file for debugging.
		newins RW/ec.RW_B.elf "ec${file_suffix}.RW_B.elf"
	fi

	if grep -q '^CONFIG_FW_INCLUDE_RO=y' .config; then
		newins RO/ec.RO.flat "ec${file_suffix}.RO.bin"
		newins RO/ec.RO.hash "ec${file_suffix}.RO.hash"
		# Intermediate file for debugging.
		newins RO/ec.RO.elf "ec${file_suffix}.RO.elf"
	fi

	# The shared objects library is not built by default.
	if grep -q '^CONFIG_SHAREDLIB=y' .config; then
		newins libsharedobjs/libsharedobjs.elf "libsharedobjs${file_suffix}.elf"
	fi

	if [[ -f chip/npcx/spiflashfw/npcx_monitor.bin ]]; then
		doins chip/npcx/spiflashfw/npcx_monitor.bin
	fi
	popd > /dev/null

	if [[ "${board}" == "cr50" ]]; then
		install_cr50_signer_aid "${dest_dir}"
	fi
}

src_install() {
	set_build_env

	local target

	einfo "Installing targets: ${EC_BOARDS[@]}"
	for target in "${EC_BOARDS[@]}"; do
		board_install "${target}" "${WORKDIR}/build_${target}" \
			"/firmware/${target}" "" \
			|| die "Couldn't install ${target}"
		if use bootblock_in_ec && \
		   [[ -d "${WORKDIR}/build_${target}_serial" ]]; then
			board_install "${target}" "${WORKDIR}/build_${target}_serial" \
				"/firmware/${target}" serial \
				|| die "Couldn't install ${target} (serial)"
		fi
	done
	# Unibuild platforms don't have "main" EC firmware.
	if ! use unibuild; then
		target="${EC_BOARDS[0]}"
		board_install "${target}" "${WORKDIR}/build_${target}" \
			/firmware "" \
			|| die "Couldn't install main firmware"
		if use bootblock_in_ec && \
		   [[ -d "${WORKDIR}/build_${target}_serial" ]]; then
			board_install "${target}" "${WORKDIR}/build_${target}_serial" \
				/firmware serial \
				|| die "Couldn't install main firmware"
		fi
	fi

	if use fuzzer ; then
		local f

		insinto /usr/libexec/fuzzers
		exeinto /usr/libexec/fuzzers
		for f in build/host/*_fuzz/*_fuzz.exe; do
			local fuzzer="$(basename "${f}")"
			local custom_owners="${S}/fuzz/${fuzzer%exe}owners"
			fuzzer="ec_${fuzzer%_fuzz.exe}_fuzzer"
			newexe "${f}" "${fuzzer}"
			einfo "CUSTOM OWNERS = '${custom_owners}'"
			if [[ -f "${custom_owners}" ]]; then
				newins "${custom_owners}" "${fuzzer}.owners"
			else
				newins "${S}/OWNERS" "${fuzzer}.owners"
			fi
		done
	fi
}

src_test() {
	set_build_env

	# Verify compilation of all boards
	emake "${EC_OPTS[@]}" buildall
}
