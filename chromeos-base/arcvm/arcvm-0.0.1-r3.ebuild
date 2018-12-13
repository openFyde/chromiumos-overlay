# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="25a5cbf24eda611a7c4a09d69733ef8758f02f28"
CROS_WORKON_TREE=("6f3635a6f5b0951a7ffdebd896518c01b04cc21b" "156cb89b22ec235ca11fa8d9e225dfc3d4b305b1" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
KEYWORDS="*"

src_install() {
	insinto /etc/init
	doins arc/vm/init/arcvm.conf
	doins arc/vm/init/arc-server-proxy.conf
	insinto /etc/dbus-1/system.d
	doins arc/vm/init/dbus-1/ArcVmUpstart.conf
}
