# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6fb68e118050011bb06e525e8d702bfa6ee88b28"
CROS_WORKON_TREE=("ea1c2b11cdf389a2c865c0221f69d6addfe4ded0" "2b6d4230c92e83e39209823855064483eed04754" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	dolib.a "${OUT}"/libdm-bht.a
	dobin "${OUT}"/verity

	insinto /usr/include/verity
	doins dm-bht.h dm-bht-userspace.h
	cd include || die
	doins -r asm-generic
}

platform_pkg_test() {
	platform_test "run" "${OUT}/verity_tests"
}
