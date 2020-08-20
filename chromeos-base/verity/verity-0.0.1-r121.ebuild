# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a47361bb6d4bb9c879cba7b2c546ab94826c77ec"
CROS_WORKON_TREE="46c7adf66cfb6ac7d52c024d753e4ba90ec8fd68"
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
