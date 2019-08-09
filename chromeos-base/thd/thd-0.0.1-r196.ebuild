# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="f8e07dae2ad8c152a76d7c76e3cbf9cf2471dcfb"
CROS_WORKON_TREE=("34ec149bfffef93be14397dd8372e9c1bdbe7bfe" "d5c6186bfb6daaeed41e71864a4a229318ec6237" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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

RDEPEND="chromeos-base/libbrillo"
DEPEND="${RDEPEND}"

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
