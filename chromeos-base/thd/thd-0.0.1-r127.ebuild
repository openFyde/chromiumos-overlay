# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="454ffd6a1dbe9453ae0bb195527c0c177de8f0f9"
CROS_WORKON_TREE=("2f1d4740f7526c3ca07c57fafce24c403436c0ad" "1d649c708013c153dd770d9d74a1f6ac36804f66" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
