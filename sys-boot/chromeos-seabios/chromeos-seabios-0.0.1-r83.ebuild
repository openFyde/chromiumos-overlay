# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3004147dd3707e600772ec6c5d37beac7f4b8eb4"
CROS_WORKON_TREE="86739723f748584f03ca50902660cae0adbc1cbf"
CROS_WORKON_PROJECT="chromiumos/third_party/seabios"
CROS_WORKON_LOCALNAME="seabios"

inherit toolchain-funcs cros-workon coreboot-sdk

DESCRIPTION="Open Source implementation of X86 BIOS"
HOMEPAGE="http://www.coreboot.org/SeaBIOS"
LICENSE="GPL-2"
KEYWORDS="-* amd64 x86"
IUSE="coreboot-sdk fwserial"

# Directory where the generated files are looked for and placed.
CROS_FIRMWARE_IMAGE_DIR="/firmware"
CROS_FIRMWARE_ROOT="${SYSROOT%/}${CROS_FIRMWARE_IMAGE_DIR}"

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

	mkdir staging
	cp out/bios.bin.elf staging/seabios.noserial.elf
	# Select which version is the default
	if ! use fwserial; then
		cp out/bios.bin.elf staging/seabios.elf
	fi
	_emake clean

	echo "CONFIG_DEBUG_SERIAL=y" >> "${config}"
	_emake defconfig KCONFIG_DEFCONFIG="${config}"
	_emake
	cp out/bios.bin.elf staging/seabios.serial.elf
	if use fwserial; then
		cp out/bios.bin.elf staging/seabios.elf
	fi
}

src_install() {
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
}
