# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="aebb47adea7ec4bca325bdbca14e26b6d11b8b45"
CROS_WORKON_TREE=("08bf717c71bd677049a8653e2ed1beb823af949d" "769bbb45c3fca6c18202030e1b87d2b43e697d74" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
