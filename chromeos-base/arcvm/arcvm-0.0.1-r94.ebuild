# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="98fd3540b8d4c57607eb0e2f3af0af071af9db49"
CROS_WORKON_TREE=("fdb2f6bdb65a4fc63e472dfd681acee205c29457" "f7794beecc15e703258c252d5639dbf3e45d18f5" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
	chromeos-base/libbrillo:=
	chromeos-base/vboot_reference:=
	dev-libs/protobuf:=
"

DEPEND="
	${RDEPEND}
	media-libs/minigbm:=
	chromeos-base/system_api:=
"

src_install() {
	newbin "${OUT}"/server_proxy arcvm_server_proxy
	dobin "${OUT}"/arcvm-launch

	insinto /etc/init
	doins init/arcvm-server-proxy.conf
	doins init/arcvm.conf

	insinto /etc/dbus-1/system.d
	doins init/dbus-1/ArcVmUpstart.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/vsock_proxy_test"
}
