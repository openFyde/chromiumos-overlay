# Copyright 2012 The Chromium OS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="b2a1cab8edb60713b918fc90779dd2e74964fc52"
CROS_WORKON_TREE="c7b5a44980fe32c3ef3dc9ad21ac5413df50abe6"
CROS_WORKON_PROJECT="chromiumos/third_party/coreboot"

DESCRIPTION="coreboot's coreinfo payload"
HOMEPAGE="http://www.coreboot.org"
LICENSE="GPL-2"
KEYWORDS="-* amd64 x86"

BDEPEND="dev-embedded/coreboot-sdk:="
DEPEND="sys-boot/libpayload:="

CROS_WORKON_LOCALNAME="coreboot"

inherit cros-workon coreboot-sdk

src_compile() {
	export CROSS_COMPILE=${COREBOOT_SDK_PREFIX_x86_32}
	export CC="${CROSS_COMPILE}gcc"
	unset CFLAGS

	local coreinfodir="payloads/coreinfo"
	cp "${coreinfodir}"/config.default "${coreinfodir}"/.config
	emake -C "${coreinfodir}" \
		LIBPAYLOAD_DIR="${ROOT}/firmware/libpayload/" \
		oldconfig \
		|| die "libpayload make oldconfig failed"
	emake -C "${coreinfodir}" \
		LIBPAYLOAD_DIR="${ROOT}/firmware/libpayload/" \
		|| die "libpayload build failed"
}

src_install() {
	local src_root="payloads/coreinfo/"
	local build_root="${src_root}/build"
	local destdir="/firmware/coreinfo"

	insinto "${destdir}"
	doins "${build_root}"/coreinfo.elf
}
