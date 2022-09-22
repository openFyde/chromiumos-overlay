# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6549ea0eb91e124c3b9b75f77edc8e064b48813b"
CROS_WORKON_TREE=("7af090f4e3d17daa9e628424e4d774e246757618" "2572028b5a0e50ed8f151b2faf4c6886871f0487" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/mojo_proxy .gn"

PLATFORM_SUBDIR="arc/vm/mojo_proxy"

inherit cros-workon platform user

DESCRIPTION="ARCVM mojo proxy."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/vm/mojo_proxy"

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

pkg_preinst() {
	enewuser "arc-mojo-proxy"
	enewgroup "arc-mojo-proxy"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/mojo_proxy_test"
}
