# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cros-ec-merge-ro.eclass
# @MAINTAINER:
# Chromium OS Firmware Team
# @BUGREPORTS:
# Please report bugs via http://crbug.com/new (with label Build)
# @VCSURL: https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/master/eclass/@ECLASS@
# @BLURB: helper eclass for merging RO firmware into EC firmware
# @DESCRIPTION:
# Merges a specific RO version of firmware into the firmware that was built
# during the build.
#
# NOTE: When making changes to this class, make sure to modify all the -9999
# ebuilds that inherit it to work around http://crbug.com/220902.

if [[ -z "${_ECLASS_CROS_EC_MERGE_RO}" ]]; then
_ECLASS_CROS_EC_MERGE_RO="1"

# Check for EAPI 6+
case "${EAPI:-0}" in
0|1|2|3|4|5) die "unsupported EAPI (${EAPI}) in eclass (${ECLASS})" ;;
*) ;;
esac

# Make sure that private files ebuild has run since it creates the symlink
# used in the src_install step below.
DEPEND="virtual/chromeos-ec-private-files"

# @FUNCTION: cros-ec-merge-ro_do_merge
# @USAGE: <RO firmware path> <RW firmware path>
# @INTERNAL
# @DESCRIPTION:
# Copy RO firmware from firmware specified in <RO firmware path> and RW firmware
# from <RW firmware path> into a new file. Returns the filename
# of the new file.
cros-ec-merge-ro_do_merge() {
	local ec_ro="$1"
	local ec_rw="$2"

	einfo "Merging RO firmware"

	# Print RO and RW versions.
	local fmap_frid
	local fmap_fwid
	IFS=" " read -r -a fmap_frid <<< "$(dump_fmap -p "${ec_ro}" RO_FRID || die)"
	IFS=" " read -r -a fmap_fwid <<< "$(dump_fmap -p "${ec_rw}" RW_FWID || die)"
	# fmap_frid[0]="RO_FRID" fmap_frid[1]=offset fmap_frid[2]=size (decimal)
	# Same for fmap_fwid.
	local ro_version_string="$(dd bs=1 skip="${fmap_frid[1]}" \
		count="${fmap_frid[2]}" if="${ec_ro}" status=none || die)"
	local rw_version_string="$(dd bs=1 skip="${fmap_fwid[1]}" \
		count="${fmap_fwid[2]}" if="${ec_rw}" status=none || die)"

	einfo "Using firmware RO version: ${ro_version_string}"
	einfo "Using firmware RW version: ${rw_version_string}"

	# Use RW firmware version as file name.
	local new_file="${rw_version_string}.bin"
	# fmap_rw_section[0]="EC_RW"
	# fmap_rw_section[1]=offset
	# fmap_rw_section[2]=size (decimal)
	local fmap_rw_section
	IFS=" " read -r -a fmap_rw_section <<< "$(dump_fmap -p "${ec_ro}" EC_RW \
		|| die)"

	# Inject RW into the existing RO file.
	einfo "Merging files..."
	cp "${ec_ro}" "${new_file}" || die
	dd if="${ec_rw}" of="${new_file}" \
		bs=1 skip="${fmap_rw_section[1]}" seek="${fmap_rw_section[1]}" \
		count="${fmap_rw_section[2]}" conv=notrunc status=none || die

	echo "${new_file}"
}

# @FUNCTION: cros-ec-merge-ro_src_install
# @DESCRIPTION:
# Copy pre-built RO firmware into RW firmware that was built.
cros-ec-merge-ro_src_install() {
	debug-print-function "${FUNCNAME[0]}" "$@"

	# Use our specified board.
	local target="${FIRMWARE_EC_BOARD}"

	local firmware_bin_dir="$(readlink -f \
		"${S}/private/fingerprint/fpc/firmware-bin")"

	if [[ ! -d "${firmware_bin_dir}" ]]; then
		einfo "No RO firmware found. This is expected in a public build."
		return 0
	fi

	local fw_target="${target%%_fp}"
	local ro_fw="$(ls "${firmware_bin_dir}/${fw_target}/"*.bin || die)"

	local rw_fw="${WORKDIR}/build_${target}/${target}/ec.bin"
	local merged_fw="$(cros-ec-merge-ro_do_merge "${ro_fw}" "${rw_fw}")"
	cp "${merged_fw}" "${rw_fw}" || die
}

EXPORT_FUNCTIONS src_install

fi  # _ECLASS_CROS_EC_MERGE_RO
