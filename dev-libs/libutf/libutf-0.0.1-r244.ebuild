# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("1c77f6728f1b4aabd016a79bdccabeba93680f9b" "c17bb435be940edf1aff81469215bb6a071f3c38")
CROS_WORKON_TREE=("3f8a9a04e17758df936e248583cfb92fc484e24c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "fc022abae9d52285526cb0dda697e2bea18696ca")
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
	platform_src_install

	insinto "/usr/include/android/"
	doins "${S}/utf.h"

	dolib.a "${OUT}/libutf.a"
}
