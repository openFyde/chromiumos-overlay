# Copyright 2012 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="85b14a06205ad4309c718357829421bc4706d018"
CROS_WORKON_TREE=("4b7854d72e018cacbb3455cf56f41cee31c70fc1" "564fb269910e51bbaacfa7c076b6dd9933bfc309" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk verity .gn"

PLATFORM_SUBDIR="verity"

inherit cros-workon platform

DESCRIPTION="File system integrity image generator for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/verity/"

LICENSE="BSD-Google GPL-2"
KEYWORDS="*"

src_install() {
	dobin "${OUT}"/verity

	dolib.so "${OUT}"/lib/libdm-bht.so
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins libdm-bht.pc

	insinto /usr/include/verity
	doins dm-bht.h dm-bht-userspace.h file_hasher.h
	cd include || die
	doins -r asm-generic
}

platform_pkg_test() {
	platform_test "run" "${OUT}/verity_tests"
}
