# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="01db1e94698ec091083a252bbff75a82e266b90c"
CROS_WORKON_TREE=("be0561582cec761c3be2d8ca3ac2b966901b7d58" "5909447ba5d311d63bcc081f0046c05a5a0afa42" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk rgbkbd .gn"
CROS_WORKON_OUTOFTREE_BUILD=1

PLATFORM_SUBDIR="rgbkbd"

inherit cros-workon platform user

DESCRIPTION="A daemon for controlling an RGB backlit keyboard."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/rgbkbd/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="
	${RDEPEND}
	chromeos-base/system_api:=
"

pkg_preinst() {
	# Create user and group for RGBKBD.
	enewuser "rgbkbd"
	enewgroup "rgbkbd"
}

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
