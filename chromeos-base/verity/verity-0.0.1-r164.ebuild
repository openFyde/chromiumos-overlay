# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d9cd7a13ff9fb36f33ef08c7a6777e3a6f0608e1"
CROS_WORKON_TREE=("2033070eecbd4d9ad2e155923b146484239c18a7" "a12fd6a4a9bb1304f96e539b75d031060620947f" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
