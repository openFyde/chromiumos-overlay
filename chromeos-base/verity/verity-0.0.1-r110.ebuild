# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="240acaa806e64238b0fda54b478209b6aec430b3"
CROS_WORKON_TREE="787fd1354d4a8125ea5406ba0a9937ae7cf1896c"
CROS_WORKON_PROJECT="chromiumos/platform/dm-verity"
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon cros-common.mk

DESCRIPTION="File system integrity image generator for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dm-verity"

LICENSE="BSD-Google GPL-2"
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
	dobin "${OUT}"/verity
}
