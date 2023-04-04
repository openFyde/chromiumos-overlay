# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("53976e946ff67846962c80391d3946561c7f14d1" "c17bb435be940edf1aff81469215bb6a071f3c38")
CROS_WORKON_TREE=("5b87e97f3ddb9634fb1d975839c28e49503e94f8" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "fc022abae9d52285526cb0dda697e2bea18696ca")
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
