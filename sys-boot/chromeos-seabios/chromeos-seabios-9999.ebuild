# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_PROJECT="chromiumos/third_party/seabios"
CROS_WORKON_LOCALNAME="seabios"

inherit toolchain-funcs cros-workon coreboot-sdk

DESCRIPTION="Open Source implementation of X86 BIOS"
HOMEPAGE="http://www.coreboot.org/SeaBIOS"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="altfw coreboot-sdk"
DEPEND="!altfw? ( sys-boot/coreboot ) "

# Directory where the generated files are looked for and placed.
CROS_FIRMWARE_IMAGE_DIR="/firmware"
CROS_FIRMWARE_ROOT="${SYSROOT%/}${CROS_FIRMWARE_IMAGE_DIR}"

create_seabios_cbfs() {
	_cbfstool() { set -- cbfstool "$@"; echo "$@"; "$@" || die "'$*' failed"; }

	local suffix="$1"
	local oprom=$(echo "${CROS_FIRMWARE_ROOT}"/pci????,????.rom)
	local seabios_cbfs="seabios.cbfs${suffix}"
	local coreboot_rom="$(find "${CROS_FIRMWARE_ROOT}" -name coreboot.rom 2>/dev/null | head -n 1)"
	local cbfs_size="$(_cbfstool "${coreboot_rom}" layout | sed -E -n -e "/^'RW_LEGACY'/{s|.*size ([0-9]+).*$|\1|;p}" )"
	local vgabios="out/vgabios.bin"

	# Create empty CBFS
	_cbfstool ${seabios_cbfs} create -s ${cbfs_size} -m x86
	# Add SeaBIOS binary to CBFS
	_cbfstool ${seabios_cbfs} add-payload -f out/bios.bin.elf -n payload -c lzma
	# Add VGA option rom to CBFS, prefer native VGABIOS if it exists
	if [[ ! -f "${vgabios}" ]]; then
		vgabios="${oprom}"
	fi
	if [[ ! -f "${oprom}" ]]; then
		cbfsrom="seavgabios.rom"
	else
		cbfsrom=$(basename "${oprom}")
	fi
	_cbfstool ${seabios_cbfs} add -f "${vgabios}" -n "${cbfsrom}" -t optionrom
	# Add additional configuration
	_cbfstool ${seabios_cbfs} add -f chromeos/links -n links -t raw
	_cbfstool ${seabios_cbfs} add -f chromeos/bootorder -n bootorder -t raw
	_cbfstool ${seabios_cbfs} add -f chromeos/etc/boot-menu-key -n etc/boot-menu-key -t raw
	_cbfstool ${seabios_cbfs} add -f chromeos/etc/boot-menu-message -n etc/boot-menu-message -t raw
	_cbfstool ${seabios_cbfs} add -f chromeos/etc/boot-menu-wait -n etc/boot-menu-wait -t raw
	# Print CBFS inventory
	_cbfstool ${seabios_cbfs} print

	cp out/bios.bin.elf "legacy.elf${suffix}"
	mkdir -p "legacy${suffix}/etc"
	cp -a chromeos/* "legacy${suffix}/"
}

_emake() {
	if ! use coreboot-sdk; then
		local LD="$(tc-getLD).bfd"
		local CC="$(tc-getCC)"
		local AS="$(tc-getAS)"
	else
		local CC=${COREBOOT_SDK_PREFIX_x86_32}gcc
		local LD=${COREBOOT_SDK_PREFIX_x86_32}ld
		local AS=${COREBOOT_SDK_PREFIX_x86_32}as
	fi

	emake \
		CROSS_PREFIX="${CHOST}-" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		HOSTCC="$(tc-getBUILD_CC)" \
		LD="${LD}" \
		AS="${AS}" \
		CC="${CC} -fuse-ld=bfd" \
		AS="${AS}" \
		"$@"
}

src_compile() {
	local config="chromeos/default.config"

	_emake defconfig KCONFIG_DEFCONFIG="${config}"
	_emake
	if use altfw; then
		mkdir staging
		cp out/bios.bin.elf "staging/seabios.elf"
	else
		create_seabios_cbfs ""
	fi
	_emake clean

	echo "CONFIG_DEBUG_SERIAL=y" >> "${config}"
	_emake defconfig KCONFIG_DEFCONFIG="${config}"
	_emake
	if use altfw; then
		cp out/bios.bin.elf "staging/seabios.serial.elf"
	else
		create_seabios_cbfs ".serial"
	fi
}

src_install() {
	if use altfw; then
		local oprom=$(echo "${CROS_FIRMWARE_ROOT}"/pci????,????.rom)
		local vgabios="out/vgabios.bin"

		insinto /firmware/seabios
		doins staging/seabios*.elf

		# Add VGA option rom to CBFS, prefer native VGABIOS if it exists
		if [[ ! -f "${vgabios}" ]]; then
			vgabios="${oprom}"
		fi
		if [[ ! -f "${oprom}" ]]; then
			cbfsrom="seavgabios.rom"
		else
			cbfsrom=$(basename "${oprom}")
		fi
		insinto /firmware/seabios/oprom
		newins "${vgabios}" "${cbfsrom}"

		# Add additional configuration
		insinto /firmware/seabios/cbfs
		doins chromeos/links
		doins chromeos/bootorder
		insinto /firmware/seabios/etc
		doins chromeos/etc/boot-menu-key
		doins chromeos/etc/boot-menu-message
		doins chromeos/etc/boot-menu-wait
	else
		insinto /firmware
		doins out/bios.bin.elf seabios.cbfs seabios.cbfs.serial
		doins legacy.elf{,.serial}
		insinto /firmware/legacy
		doins -r legacy/*
		insinto /firmware/legacy.serial
		doins -r legacy.serial/*
	fi
}
