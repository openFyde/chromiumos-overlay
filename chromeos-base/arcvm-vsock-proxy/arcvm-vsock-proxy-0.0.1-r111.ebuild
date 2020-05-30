# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2db2d38b43bb1976e7dc6e220f957ef414e52770"
CROS_WORKON_TREE=("7af66dac55260dbe54518e1c164b88af55fb6af0" "1a46f53b43976227a875fb16d2508e9c2ed34e1f" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/vsock_proxy .gn"

PLATFORM_SUBDIR="arc/vm/vsock_proxy"

inherit cros-workon platform

DESCRIPTION="ARCVM vsock proxy."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/vsock_proxy"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	dev-libs/protobuf:=
	sys-fs/fuse
"

DEPEND="
	${RDEPEND}
"

src_install() {
	newbin "${OUT}"/server_proxy arcvm_server_proxy

	insinto /etc/init
	doins init/arcvm-server-proxy.conf

	insinto /etc/dbus-1/system.d
	doins init/dbus-1/ArcVmServerProxy.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/vsock_proxy_test"
}
