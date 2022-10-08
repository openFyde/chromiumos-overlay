# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="85b14a06205ad4309c718357829421bc4706d018"
CROS_WORKON_TREE=("4b7854d72e018cacbb3455cf56f41cee31c70fc1" "2572028b5a0e50ed8f151b2faf4c6886871f0487" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
