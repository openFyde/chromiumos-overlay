# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="2bf6e315d383c9a4a3b62f98a9887631c30c4cf7"
CROS_WORKON_TREE=("a049deba38a69414f9446279b569687189508f53" "fad0f23bc55764f8e9151aea53b3bc043f3801e7" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
