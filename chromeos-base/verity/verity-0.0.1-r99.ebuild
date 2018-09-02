# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="4c27ac6cef21c0b0e7cddbef1b7be32e91333267"
CROS_WORKON_TREE="6d09637b146d898915bd7f71251d5be5863a3780"
CROS_WORKON_PROJECT="chromiumos/platform/dm-verity"
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon cros-common.mk

DESCRIPTION="File system integrity image generator for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dm-verity"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gmock
		dev-cpp/gtest
	)"

src_install() {
	dolib.a "${OUT}"/libdm-bht.a
	insinto /usr/include/verity
	doins dm-bht.h dm-bht-userspace.h
	insinto /usr/include/verity
	cd include
	doins -r linux asm asm-generic crypto
	cd ..
	into /
	dobin "${OUT}"/verity-static
	dosym verity-static bin/verity
}
