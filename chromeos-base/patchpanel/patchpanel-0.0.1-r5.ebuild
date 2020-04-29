# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="84c76a19a56ea99722c4ff7fb5052ea3e176586d"
CROS_WORKON_TREE=("2b7b46ab1083cdcc8b17bd7f5b05ddff336b0559" "eaf38c6b785be6eea07ab76b9d7c8b3ba5f668f1" "86ecbe03d6f041f77f104cc9640ad776faad5a23" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk patchpanel shill/net .gn"

PLATFORM_SUBDIR="patchpanel"

inherit cros-workon libchrome platform user

DESCRIPTION="Patchpanel network connectivity management daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/network/"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer"

COMMON_DEPEND="
	dev-libs/protobuf:=
	!chromeos-base/arc-networkd
"

RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/chromeos-nat-init
	net-firewall/iptables
	net-misc/bridge-utils
	sys-apps/iproute2
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/permission_broker-client:=
	chromeos-base/session_manager-client:=
	chromeos-base/shill:=
	chromeos-base/shill-client:=
	chromeos-base/system_api:=[fuzzer?]
"

patchpanel_header() {
	doins "$1"
	sed -i '/.pb.h/! s/patchpanel\//chromeos\/patchpanel\//g' "${D}/usr/include/chromeos/patchpanel/$1" || die
}

src_install() {
	# Main binary.
	dobin "${OUT}"/patchpaneld

	# Libraries.
	dolib.so "${OUT}"/lib/libarcnetwork-util.so
	dolib.so "${OUT}"/lib/libpatchpanel-client.so

	"${S}"/preinstall.sh "${PV}" "/usr/include/chromeos" "${OUT}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/libarcnetwork-util.pc
	doins "${OUT}"/libpatchpanel-client.pc

	insinto /usr/include/chromeos/patchpanel/
	patchpanel_header address_manager.h
	patchpanel_header client.h
	patchpanel_header mac_address_generator.h
	patchpanel_header net_util.h
	patchpanel_header socket.h
	patchpanel_header socket_forwarder.h
	patchpanel_header subnet.h
	patchpanel_header subnet_pool.h

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

