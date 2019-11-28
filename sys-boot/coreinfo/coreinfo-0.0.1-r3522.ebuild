# Copyright 2012 The Chromium OS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="de5450539832109d68560e0343db1e72e87b6dab"
CROS_WORKON_TREE="9a1a49d7b3ff2a31b26d3ceaa6ea6fa739b5cf39"
CROS_WORKON_PROJECT="chromiumos/third_party/coreboot"

DESCRIPTION="coreboot's coreinfo payload"
HOMEPAGE="http://www.coreboot.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="coreboot-sdk"

RDEPEND="sys-boot/libpayload"
DEPEND="sys-boot/libpayload"

CROS_WORKON_LOCALNAME="coreboot"

inherit cros-workon toolchain-funcs coreboot-sdk

src_compile() {
	if ! use coreboot-sdk; then
		export CROSS_COMPILE=i686-pc-linux-gnu-
	else
		export CROSS_COMPILE=${COREBOOT_SDK_PREFIX_x86_32}
	fi
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
