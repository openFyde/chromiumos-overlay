# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4481e87cb1f0478266277ee28a31db1b8e53e3b6"
CROS_WORKON_TREE=("8a107d83e7e0a12f330005e0cd66720e3d854a2e" "0c19659fdf322b30e3cef033b7f21d7a529f58a4" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
