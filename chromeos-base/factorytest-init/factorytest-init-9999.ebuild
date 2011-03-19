# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit cros-workon

DESCRIPTION="Upstart jobs for the Chrome OS factory test image"
HOMEPAGE="http://src.chromium.org"
SRC_URI=""
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~arm"
IUSE=""

DEPEND=""

RDEPEND="chromeos-base/chromeos-init
	sys-apps/coreutils
	sys-apps/module-init-tools
	sys-apps/upstart
	sys-process/procps
	"

CROS_WORKON_LOCALNAME="factory_test_init"
CROS_WORKON_PROJECT="factory_test_init"

src_install() {
	dodir /etc/init
	insinto /etc/init
	doins factory.conf
	doins factorylog.conf
}
