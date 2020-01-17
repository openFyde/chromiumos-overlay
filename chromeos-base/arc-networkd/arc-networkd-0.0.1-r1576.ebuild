# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ba04fe376238be63947d8d110819b506557c7c9d"
CROS_WORKON_TREE=("7010e07aca1a8f5685729ec7fc8a7691a7ae2808" "243636760128ee1d730cae7b477a2a95c6f4f598" "1fc20bff17ee132f5ff09103cc4ef128176e02f8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
KEYWORDS="*"
IUSE="fuzzer"

COMMON_DEPEND="
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
	chromeos-base/shill:=
	chromeos-base/shill-client:=
	chromeos-base/system_api:=[fuzzer?]
"

src_install() {
	# Main binary.
	dobin "${OUT}"/arc-networkd

	# Libraries.
	dolib.so "${OUT}"/lib/libarcnetwork-util.so
	dolib.so "${OUT}"/lib/libpatchpanel-client.so

	"${S}"/preinstall.sh "${PV}" "/usr/include/chromeos" "${OUT}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/libarcnetwork-util.pc
	doins "${OUT}"/libpatchpanel-client.pc

	insinto /usr/include/arc/network/
	doins client.h
	doins mac_address_generator.h
	doins subnet.h
	doins subnet_pool.h

	insinto /etc/init
	doins "${S}"/init/arc-network-bridge.conf

	insinto /etc/dbus-1/system.d
	doins dbus/*.conf

	local fuzzer
	for fuzzer in "${OUT}"/*_fuzzer; do
		platform_fuzzer_install "${S}"/OWNERS "${fuzzer}"
	done
}

pkg_preinst() {
	# Service account used for privilege separation.
	enewuser arc-networkd
	enewgroup arc-networkd
}

platform_pkg_test() {
	platform_test "run" "${OUT}/arc_network_testrunner"
}

