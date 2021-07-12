# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("4b4eb59cfb0011afa7ea6b79d6bca62acb8a0606" "c17bb435be940edf1aff81469215bb6a071f3c38")
CROS_WORKON_TREE=("487d577f0b2a08f0526aabf33ec63115fe32a16c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "fc022abae9d52285526cb0dda697e2bea18696ca")
CROS_WORKON_LOCALNAME=("../platform2" "../aosp/external/libutf")
CROS_WORKON_PROJECT=("chromiumos/platform2" "aosp/platform/external/libutf")
CROS_WORKON_EGIT_BRANCH=("main" "master")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/libutf")
CROS_WORKON_SUBTREE=("common-mk .gn" "")

PLATFORM_SUBDIR="libutf"

inherit cros-workon platform

DESCRIPTION="A UTF-8 library based on the AOSP version of libutf."
HOMEPAGE="https://chromium.googlesource.com/aosp/platform/external/libutf/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""
DEPEND=""

src_install() {
	insinto "/usr/include/android/"
	doins "${S}/utf.h"

	dolib.a "${OUT}/libutf.a"
}
