# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="44ec8b5e0f9c2b6b05721ba4e5f7d94db99ac5c2"
CROS_WORKON_TREE=("232eeac462515f4e1460770a38b8ac52bef0adec" "066da0b61ea3fbafad419e546f6530d8d3b25553" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	platform_src_install

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
