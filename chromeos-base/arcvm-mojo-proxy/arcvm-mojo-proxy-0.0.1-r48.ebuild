# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="60d1fad8686e56d4e6ae78fc5041ab6540542564"
CROS_WORKON_TREE=("1f02e90df08e7f8c0093b14f2660828e06d87ef7" "f1a3e4ff4103d5e0d2dd4c9f705a5c3cc14fd97a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/mojo_proxy .gn"

PLATFORM_SUBDIR="arc/vm/mojo_proxy"

inherit cros-workon platform

DESCRIPTION="ARCVM mojo proxy."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/mojo_proxy"

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
}

platform_pkg_test() {
	platform_test "run" "${OUT}/mojo_proxy_test"
}
