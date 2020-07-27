# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="838cda3c91026318250ceaa3862fa0d3c356e7d5"
CROS_WORKON_TREE=("cf397e9600a0b2d153f579c58419577cfca75ab7" "b3712f542da443196979fe4302d3a2ebf7e72844" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk typecd .gn"

PLATFORM_SUBDIR="typecd"

inherit cros-workon platform user

DESCRIPTION="Chrome OS USB Type C daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/typecd/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

src_install() {
	dobin "${OUT}"/typecd

	insinto /etc/init
	doins init/*.conf
}

pkg_preinst() {
	enewuser typecd
	enewgroup typecd
}

platform_pkg_test() {
	platform_test "run" "${OUT}/typecd_testrunner"
}
