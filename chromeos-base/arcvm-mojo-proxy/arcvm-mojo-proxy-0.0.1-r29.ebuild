# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0445fad116fa1fc412b4dc4368e7b204cb6ad7fc"
CROS_WORKON_TREE=("bf90d72feeef97f2eed78621b91da11dc16e9927" "e23cacccf4a8be891ad29fabf2c717600327a772" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

# This package was renamed from  arcvm-vsock-proxy. Put a blocker to uninstall
# the old package.
# TODO(hashimoto): Remove this blocker later.
RDEPEND="
	!chromeos-base/arcvm-vsock-proxy

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
