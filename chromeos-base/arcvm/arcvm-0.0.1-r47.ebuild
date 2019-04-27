# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="66611f9d81eba5f3d61d8ff62c1bf3233ccb80e9"
CROS_WORKON_TREE=("2f72a5edb8d5f40c8d31f932ebcbcc7452a30492" "bdeb47152a18dbcd2d951956c725886f78c6cf22" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm .gn"

PLATFORM_SUBDIR="arc/vm"

inherit cros-workon platform

DESCRIPTION="A package to run arcvm."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
	dev-libs/protobuf:=
"

DEPEND="${RDEPEND}"

src_install() {
	newbin "${OUT}"/server_proxy arcvm_server_proxy

	insinto /etc/init
	doins init/arcvm.conf
	doins init/arcvm-server-proxy.conf
	insinto /etc/dbus-1/system.d
	doins init/dbus-1/ArcVmUpstart.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/vsock_proxy_test"
}
