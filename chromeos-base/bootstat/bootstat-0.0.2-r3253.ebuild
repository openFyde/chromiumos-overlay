# Copyright 2010 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1dffef3b5fa35642ed3ad2b54aa7554bf0d3ed60"
CROS_WORKON_TREE=("52639708fb7bf1a26ac114df488dc561a7ca9f3c" "02fee8d2b5d2b4bff7aafbb95dd589fa22a4a3af" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk bootstat .gn"

PLATFORM_SUBDIR="bootstat"

inherit cros-workon platform

DESCRIPTION="Chrome OS Boot Time Statistics Utilities"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/bootstat/"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	sys-apps/rootdev:=
"

RDEPEND="
	${COMMON_DEPEND}
"

DEPEND="
	${COMMON_DEPEND}
"

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
