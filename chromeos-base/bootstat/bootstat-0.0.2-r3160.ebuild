# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a25092f7721cab5ed73550232ead248bc78c2e52"
CROS_WORKON_TREE=("9ab77225a799145c1011d187b3274f5291d5ca7e" "099ee78ecfdd76a535372e12365bd5372e6e2596" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk bootstat .gn"

PLATFORM_SUBDIR="bootstat"

inherit cros-workon platform

DESCRIPTION="Chrome OS Boot Time Statistics Utilities"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/bootstat/"
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
