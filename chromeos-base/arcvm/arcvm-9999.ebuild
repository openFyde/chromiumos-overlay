# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm .gn"

inherit cros-workon

DESCRIPTION="A package to run arcvm."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"

src_install() {
	insinto /etc/init
	doins arc/vm/init/arcvm.conf
	doins arc/vm/init/arc-server-proxy.conf
	insinto /etc/dbus-1/system.d
	doins arc/vm/init/dbus-1/ArcVmUpstart.conf
}
