# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cros-debug cros-unibuild

DESCRIPTION="ChromeOS firmware image builder"
HOMEPAGE="http://www.chromium.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
# TODO(sjg@chromium.org): Remove when x86 can build all boards
BOARDS="alex aplrvp atlas auron bayleybay beltino bolt butterfly"
BOARDS="${BOARDS} chell cnlrvp coral cyan dragonegg emeraldlake2 eve falco fizz"
BOARDS="${BOARDS} fox glados glkrvp grunt jecht kalista kblrvp kunimitsu link"
BOARDS="${BOARDS} lumpy lumpy64 mario meowth nasher nami nautilus nocturne"
BOARDS="${BOARDS} octopus panther parrot peppy poppy pyro rambi rammus reef"
BOARDS="${BOARDS} samus sand sarien sklrvp slippy snappy"
BOARDS="${BOARDS} soraka squawks stout strago stumpy sumo zoombini"
IUSE="${BOARDS} altfw seabios"
IUSE="${IUSE} fsp fastboot unibuild u-boot tianocore cros_ec pd_sync +bmpblk"

REQUIRED_USE="
	^^ ( ${BOARDS} arm mips )
"

DEPEND="
	sys-boot/coreboot
	sys-boot/depthcharge
	bmpblk? ( sys-boot/chromeos-bmpblk )
	tianocore? ( sys-boot/edk2 )
	seabios? ( sys-boot/chromeos-seabios )
	unibuild? ( chromeos-base/chromeos-config )
	u-boot? ( sys-boot/u-boot )
	cros_ec? ( chromeos-base/chromeos-ec )
	pd_sync? ( chromeos-base/chromeos-ec )
	"

# Directory where the generated files are looked for and placed.
CROS_FIRMWARE_IMAGE_DIR="/firmware"
CROS_FIRMWARE_ROOT="${ROOT%/}${CROS_FIRMWARE_IMAGE_DIR}"

S=${WORKDIR}

do_cbfstool() {
	local output
	output=$(cbfstool "$@" 2>&1)
	if [ $? != 0 ]; then
		die "Failed cbfstool invocation: cbfstool $@\n${output}"
	fi
	printf "${output}"
}

sign_region() {
	local fw_image=$1
	local keydir=$2
	local slot=$3

	local tmpfile=`mktemp`
	local cbfs=FW_MAIN_${slot}
	local vblock=VBLOCK_${slot}

	do_cbfstool ${fw_image} read -r ${cbfs} -f ${tmpfile}
	local size=$(do_cbfstool ${fw_image} print -k -r ${cbfs} | \
		tail -1 | \
		sed "/(empty).*null/ s,^(empty)[[:space:]]\(0x[0-9a-f]*\)\tnull\t.*$,\1,")
	size=$(printf "%d" ${size})

	# If the last entry is called "(empty)" and of type "null", remove it from
	# the section so it isn't part of the signed data, to improve boot speed
	# if (as often happens) there's a large unused suffix.
	if [ -n "${size}" ] && [ ${size} -gt 0 ]; then
		head -c ${size} ${tmpfile} > ${tmpfile}.2
		mv ${tmpfile}.2 ${tmpfile}
		# Use 255 (aka 0xff) as the filler, this greatly reduces
		# memory areas which need to be programmed for spi flash
		# chips, because the erase value is 0xff.
		do_cbfstool ${fw_image} write --force -u -i 255 \
			-r ${cbfs} -f ${tmpfile}
	fi

	futility vbutil_firmware \
		--vblock ${tmpfile}.out \
		--keyblock ${keydir}/firmware.keyblock \
		--signprivate ${keydir}/firmware_data_key.vbprivk \
		--version 1 \
		--fv ${tmpfile} \
		--kernelkey ${keydir}/kernel_subkey.vbpubk \
		--flags 0

	do_cbfstool ${fw_image} write -u -i 0 -r ${vblock} -f ${tmpfile}.out

	rm -f ${tmpfile} ${tmpfile}.out
}

sign_image() {
	local fw_image=$1
	local keydir=$2

	sign_region "${fw_image}" "${keydir}" A
	sign_region "${fw_image}" "${keydir}" B
}

add_payloads() {
	local fw_image=$1
	local ro_payload=$2
	local rw_payload=$3

	do_cbfstool ${fw_image} add-payload \
		-f ${ro_payload} -n fallback/payload -c lzma

	do_cbfstool ${fw_image} add-payload \
		-f ${rw_payload} -n fallback/payload -c lzma -r FW_MAIN_A,FW_MAIN_B
}

# Returns true if EC supports EFS.
is_ec_efs_enabled() {
	local coreboot_config="$1"

	grep -q "^CONFIG_VBOOT_EC_EFS=y$" "${coreboot_config}"
}

add_ec() {
	local coreboot_config="$1"
	local rom="$2"
	local name="$3"
	local ecroot="$4"
	local pad="0"

	is_ec_efs_enabled "${coreboot_config}" && pad="128"
	einfo "Padding ecrw ${pad} byte."
	cbfstool "${rom}" add -r FW_MAIN_A,FW_MAIN_B -t raw -c lzma \
		-f "${ecroot}/ec.RW.bin" -n "${name}" -p "${pad}" || die
	cbfstool "${rom}" add -r FW_MAIN_A,FW_MAIN_B -t raw -c none \
		-f "${ecroot}/ec.RW.hash" -n "${name}.hash" || die
}

# Add payloads and sign the image.
# This takes the base image and creates a new signed one with the given
# payloads added to it.
# The image is placed in directory ${outdir} ("" for current directory).
# An image suffix is added is ${suffix} is non-empty (e.g. "dev", "net").
# Args:
#   $1: Image type (e,g. "" for standard image, "dev" for dev image)
#   $2: Source image to start from.
#   $3: Payload to add to read-only image portion
#   $4: Payload to add to read-write image portion
build_image() {
	local image_type=$1
	local src_image=$2
	local ro_payload=$3
	local rw_payload=$4
	local devkeys_dir="${ROOT%/}/usr/share/vboot/devkeys"

	[ -n "${image_type}" ] && image_type=".${image_type}"
	local dst_image="${outdir}image${suffix}${image_type}.bin"

	einfo "Building image ${dst_image}"
	cp ${src_image} ${dst_image}
	add_payloads ${dst_image} ${ro_payload} ${rw_payload}
	sign_image ${dst_image} "${devkeys_dir}"
}

# Set up alternative bootloaders
#
# This creates a new CBFS in the RW_LEGACY area and puts bootloaders into it,
# based on USE flags. A list is written to an "altfw/list" file so that there
# is a record of what is available.
# Args:
#   $1: coreboot file to add to (will add to this and the .serial version of it)
setup_altfw() {
	local coreboot_file="$1"
	local cbfs="altfw.cbfs"
	local bl_list="altfw"

	einfo "Adding alternative firmware"
	# Input: "'RW_LEGACY' (size 7864320, offset 4718592)"
	# Output: "7864320"
	local cbfs_size="$(do_cbfstool "${coreboot_file}" layout | \
		sed -e "/^'RW_LEGACY'/ {s|.*size \([0-9]*\)[^0-9].*$|\1|; q}; d" )"

	# Create a new, empty CBFS file
	# Suppress message "Created CBFS (capacity = 7864216 bytes)"
	do_cbfstool "${cbfs}" create -s "${cbfs_size}" -m x86 >/dev/null
	rm -f "${bl_list}"

	# Add U-Boot if enabled
	if use u-boot; then
		einfo "- Adding U-Boot"

		do_cbfstool "${cbfs}" add-flat-binary -n altfw/u-boot \
			-c lzma -l 0x1110000 -e 0x1110000 \
			-f "${CROS_FIRMWARE_ROOT}/u-boot.bin"
		echo "1;altfw/u-boot;U-Boot;U-Boot bootloader" >> "${bl_list}"
	fi

	# Add TianoCore if enabled
	if use tianocore; then
		einfo "- Adding TianoCore"

		do_cbfstool "${cbfs}" add-payload -n altfw/tianocore -c lzma \
			-f "${CROS_FIRMWARE_ROOT}/tianocore/UEFIPAYLOAD.fd"
		echo "2;altfw/tianocore;TianoCore;TianoCore bootloader" \
			>> "${bl_list}"

		# For now, use TianoCore as the default
		echo "0;altfw/tianocore;TianoCore;TianoCore bootloader" \
			>> "${bl_list}"
	fi

	# Add SeaBIOS if enabled
	if use seabios; then
		local root="${CROS_FIRMWARE_ROOT}/seabios/"
		einfo "- Adding SeaBIOS"

		do_cbfstool "${cbfs}" add-payload -n altfw/seabios -c lzma \
			-f "${root}/seabios.elf"
		for f in "${root}oprom/"*; do
			if [[ -f "${f}" ]]; then
				do_cbfstool ${cbfs} add -f "${f}" \
					-n "${f#${root}oprom/}" -t optionrom
			fi
		done
		for f in "${root}cbfs/"*; do
			if [[ -f "${f}" ]]; then
				do_cbfstool ${cbfs} add -f "${f}" \
					-n "${f#${root}cbfs/}" -t raw
			fi
		done
		for f in "${root}"etc/*; do
			do_cbfstool ${cbfs} add -f "${f}" -n "${f#$root}" -t raw
		done
		echo "3;altfw/seabios;SeaBIOS;SeaBIOS bootloader" \
			>> "${bl_list}"
	fi

	# Add the list
	einfo "- adding firmware list"
	do_cbfstool "${cbfs}" add -n altfw/list -t raw -f "${bl_list}"

	# Add the tag for silent updating.
	do_cbfstool "${cbfs}" add-int -i 1 -n "cros_allow_auto_update"

	# TODO(kitching): Get hash and sign.

	# Write this CBFS file into the RW_LEGACY region
	do_cbfstool "${coreboot_file}" write -f "${cbfs}" -r RW_LEGACY --force
	do_cbfstool "${coreboot_file}.serial" write -f "${cbfs}" -r RW_LEGACY \
		--force
}

# Build firmware images for a given board
# Creates image*.bin for the following images:
#    image.bin          - production image (no serial console)
#    image.serial.bin   - production image with serial console enabled
#    image.dev.bin      - developer image with serial console enabled
#    image.net.bin      - netboot image with serial console enabled
#    image.fastboot.bin - fastboot image with serial console enabled
#    image.fastboot-prod.bin - fastboot image (no serial console)
#
# If $2 is set, then it uses "image-$2" instead of "image" and puts images in
# the $2 subdirectory.
#
# If outdir
# Args:
#   $1: Directory containing the input files:
#       coreboot.rom             - coreboot ROM image containing various pieces
#       coreboot.rom.serial      - same, but with serial console enabled
#       depthcharge/depthcharge.elf - depthcharge ELF payload
#       depthcharge/dev.elf      - developer version of depthcharge
#       depthcharge/netboot.elf  - netboot version of depthcharge
#       depthcharge/fastboot.elf - fastboot version of depthcharge
#       compressed-assets-ro/*   - fonts, images and screens for recovery mode
#                                  originally from cbfs-ro-compress/*,
#                                  pre-compressed in src_compile
#       compressed-assets-rw/*   - files originally from cbfs-rw-compress/*,
#                                  pre-compressed in src_compile
#                                  used for vbt*.bin
#   $2: Name to use when naming output files (see note above, can be empty)
#
#   $3: Name of target to build for coreboot (can be empty)
#
#   $4: Name of target to build for depthcharge (can be empty)
#
#   $5: Name of target to build for ec (can be empty)
build_images() {
	local froot="$1"
	local build_name="$2"
	local coreboot_build_target="$3"
	local depthcharge_build_target="$4"
	local ec_build_target="$5"
	local outdir
	local suffix

	local coreboot_file
	local coreboot_config
	local depthcharge_prefix

	if [ -n "${build_name}" ]; then
		einfo "Building firmware images for ${build_name}"
		outdir="${build_name}/"
		mkdir "${outdir}"
		suffix="-${build_name}"
		coreboot_file="${froot}/${coreboot_build_target}/coreboot.rom"
		coreboot_config="${froot}/${coreboot_build_target}/coreboot.config"
		depthcharge_prefix="${froot}/${depthcharge_build_target}"
	else
		coreboot_file="${froot}/coreboot.rom"
		coreboot_config="${froot}/coreboot.config"
		depthcharge_prefix="${froot}"
	fi

	cp ${coreboot_file} coreboot.rom
	cp ${coreboot_file}.serial coreboot.rom.serial
	coreboot_file=coreboot.rom

	for file in $(find compressed-assets-ro -type f 2>/dev/null); do
		for rom in ${coreboot_file}{,.serial}; do
			do_cbfstool ${rom} add \
				-r COREBOOT \
				-f $file -n $(basename $file) -t raw \
				-c precompression
		done
	done

	for file in $(find compressed-assets-rw -type f 2>/dev/null); do
		for rom in ${coreboot_file}{,.serial}; do
			do_cbfstool ${rom} add \
				-r COREBOOT,FW_MAIN_A,FW_MAIN_B \
				-f $file -n $(basename $file) -t raw \
				-c precompression
		done
	done

	if [[ -d ${froot}/cbfs ]]; then
		die "something is still using ${froot}/cbfs, which is deprecated."
	fi

	if use cros_ec; then
		if use unibuild; then
			einfo "Adding EC for ${ec_build_target}"
			add_ec "${coreboot_config}" "${coreboot_file}" "ecrw" "${froot}/${ec_build_target}"
			add_ec "${coreboot_config}" "${coreboot_file}.serial" "ecrw" "${froot}/${ec_build_target}"
		else
			add_ec "${coreboot_config}" "${coreboot_file}" "ecrw" "${froot}"
			add_ec "${coreboot_config}" "${coreboot_file}.serial" "ecrw" "${froot}"
		fi
	fi

	if use pd_sync; then
		add_ec "${coreboot_config}" "${coreboot_file}" "pdrw" "${froot}/${PD_FIRMWARE}"
		add_ec "${coreboot_config}" "${coreboot_file}.serial" "pdrw" "${froot}/${PD_FIRMWARE}"
	fi

	if use altfw; then
		setup_altfw "${coreboot_file}"
	fi

	local depthcharge="${depthcharge_prefix}/depthcharge/depthcharge.elf"
	local depthcharge_dev="${depthcharge_prefix}/depthcharge/dev.elf"
	local netboot="${depthcharge_prefix}/depthcharge/netboot.elf"
	local fastboot="${depthcharge_prefix}/depthcharge/fastboot.elf"

	build_image "" "${coreboot_file}" "${depthcharge}" "${depthcharge}"

	build_image serial "${coreboot_file}.serial" \
		"${depthcharge}" "${depthcharge}"

	build_image dev "${coreboot_file}.serial" \
		"${depthcharge_dev}" "${depthcharge_dev}"

	# Build a netboot image.
	#
	# The readonly payload is usually depthcharge and the read/write
	# payload is usually netboot. This way the netboot image can be used
	# to boot from USB through recovery mode if necessary.
	build_image net "${coreboot_file}.serial" "${depthcharge}" "${netboot}"

	# Set convenient netboot parameter defaults for developers.
	local bootfile="${PORTAGE_USERNAME}/${BOARD_USE}/vmlinuz"
	local argsfile="${PORTAGE_USERNAME}/${BOARD_USE}/cmdline"
	netboot_firmware_settings.py \
		-i "${outdir}image${suffix}.net.bin" \
		--bootfile="${bootfile}" --argsfile="${argsfile}" &&
		netboot_firmware_settings.py \
			-i "${outdir}image${suffix}.dev.bin" \
			--bootfile="${bootfile}" --argsfile="${argsfile}" ||
		die "failed to preset netboot parameter defaults."
	einfo "Netboot configured to boot ${bootfile}, fetch kernel command" \
		"line from ${argsfile}, and use the DHCP-provided TFTP server IP."

	if use fastboot ; then
		build_image fastboot "${coreboot_file}.serial" \
			"${fastboot}" "${depthcharge}"

		build_image fastboot-prod "${coreboot_file}" \
			"${fastboot}" "${depthcharge}"
	fi
}

src_compile() {
	local froot="${CROS_FIRMWARE_ROOT}"
	einfo "Compressing static assets"

	if [[ -d ${froot}/rocbfs ]]; then
		die "something is still using ${froot}/rocbfs, which is deprecated."
	fi

	# files from cbfs-ro-compress/ are installed in
	# all images' RO CBFS, compressed
	mkdir compressed-assets-ro
	find ${froot}/cbfs-ro-compress -mindepth 1 -maxdepth 1 -printf "%P\0" \
		2>/dev/null | \
		xargs -0 -n 1 -P $(nproc) -I '{}' \
		cbfs-compression-tool compress ${froot}/cbfs-ro-compress/'{}' \
			compressed-assets-ro/'{}' LZMA

	# files from cbfs-rw-compress/ are installed in
	# all images' RO/RW CBFS, compressed
	mkdir compressed-assets-rw
	find ${froot}/cbfs-rw-compress -mindepth 1 -maxdepth 1 -printf "%P\0" \
		2>/dev/null | \
		xargs -0 -n 1 -P $(nproc) -I '{}' \
		cbfs-compression-tool compress ${froot}/cbfs-rw-compress/'{}' \
			compressed-assets-rw/'{}' LZMA

	if use unibuild; then
		local fields="coreboot,depthcharge,ec"
		local cmd="get-firmware-build-combinations"
		(cros_config_host "${cmd}" "${fields}" || die) |
		while read -r name; do
			read -r coreboot
			read -r depthcharge
			read -r ec
			einfo "Building image for: ${name}"
			build_images ${froot} ${name} ${coreboot} ${depthcharge} ${ec}
		done
	else
		build_images "${froot}" "" "" "" ""
	fi
}

src_install() {
	insinto "${CROS_FIRMWARE_IMAGE_DIR}"
	if use unibuild; then
		local fields="coreboot,depthcharge"
		local cmd="get-firmware-build-combinations"
		(cros_config_host "${cmd}" "${fields}" || die) |
		while read -r name; do
			read -r coreboot
			read -r depthcharge
			doins "${name}"/image-${name}*.bin
		done
	else
		doins image*.bin
	fi
}
