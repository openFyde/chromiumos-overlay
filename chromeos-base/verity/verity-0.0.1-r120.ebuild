# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4c1a3b764ca301f5a28a681f537f1a9298f3d0ce"
CROS_WORKON_TREE="a7b2614d0a6403bb90e0310341a4eaf666d3659e"
CROS_WORKON_PROJECT="chromiumos/platform/dm-verity"
CROS_WORKON_LOCALNAME="platform/verity"
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon cros-common.mk

DESCRIPTION="File system integrity image generator for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dm-verity"

# Override default S as verity source code must be compiled in a directory
# where the last leaf is 'verity'.
S="${WORKDIR}/${PN}"

LICENSE="BSD-Google GPL-2"
KEYWORDS="*"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gtest:=
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
