# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("1dffef3b5fa35642ed3ad2b54aa7554bf0d3ed60" "c17bb435be940edf1aff81469215bb6a071f3c38")
CROS_WORKON_TREE=("52639708fb7bf1a26ac114df488dc561a7ca9f3c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "fc022abae9d52285526cb0dda697e2bea18696ca")
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
