# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="53d6ed3c6ff79c473af357f514689e5b847cf262"
CROS_WORKON_TREE=("b5b115b2b168baedba931733a4baaa59c593baf3" "ece498561dfd2919d08524f2ad5d5c60982feb4b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk thd .gn"

PLATFORM_SUBDIR="thd"

inherit cros-workon platform user

DESCRIPTION="Thermal Daemon for Chromium OS"
HOMEPAGE="http://dev.chromium.org/chromium-os/packages/thd"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

pkg_preinst() {
	enewuser thermal
	enewgroup thermal
}

src_install() {
	dobin "${OUT}"/thd

	dodir /etc/thd/

	insinto /etc/init
	doins init/*.conf
}
