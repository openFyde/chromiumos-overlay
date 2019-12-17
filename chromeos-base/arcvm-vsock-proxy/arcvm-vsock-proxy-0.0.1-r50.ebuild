# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="db92bbeab1581f9eb8755de9323b089fc042fa87"
CROS_WORKON_TREE=("27d7d5f2d4de786738c22f9ded288cce7eed6a7c" "c6958ffded1611933613f6d4b102f8cd9ba42bc0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
