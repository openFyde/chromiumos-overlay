# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="f132e802fae0622b7ca1427e737944dc62dc7b7b"
CROS_WORKON_TREE=("bf84a23a00350764b97d4ceb2bee5c17164d7855" "3c6910a3d82bec1ead7e2e50c94d8d12fb89a617" "8d557c989ac947f9a50026dbe88957c7c842efc8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(garrick): Workaround for https://crbug.com/809389
CROS_WORKON_SUBTREE="common-mk arc/network shill/net .gn"

PLATFORM_SUBDIR="arc/network"

inherit cros-workon libchrome platform user

DESCRIPTION="ARC connectivity management daemon"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/libbrillo
	dev-libs/protobuf:=
	net-libs/libndp
"

RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/chromeos-nat-init
	net-misc/bridge-utils
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/shill
	chromeos-base/shill-client
	chromeos-base/system_api
"

src_install() {
	# Main binary.
	dobin "${OUT}"/arc-networkd

	# Utility library.
	dolib.so "${OUT}"/lib/libarcnetwork-util.so

	"${S}"/preinstall.sh "${PV}" "/usr/include/chromeos" "${OUT}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/libarcnetwork-util.pc

	insinto /usr/include/arc/network/
	doins mac_address_generator.h
	doins subnet.h
	doins subnet_pool.h

	insinto /etc/init
	doins "${S}"/init/arc-network.conf
	doins "${S}"/init/arc-network-bridge.conf
}

pkg_preinst() {
	# Service account used for privilege separation.
	enewuser arc-networkd
	enewgroup arc-networkd
}

platform_pkg_test() {
	platform_test "run" "${OUT}/arc_network_testrunner"
}

