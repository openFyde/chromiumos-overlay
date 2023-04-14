# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="360fa3b346c7afb85ae559e82dab0acb83817efc"
CROS_WORKON_TREE=("4d05be6aacce39f0ffed0cb00fc7d88926121b65" "a2002e5b021a481c966a494642397c400fe65c93" "773eb16671033265eca73eaf18b7473a8519879d" "ee2eeefe5989cabc67a818840edb8169d64e5b3d" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk metrics patchpanel shill/net .gn"

PLATFORM_SUBDIR="patchpanel"

inherit cros-workon libchrome platform user

DESCRIPTION="Patchpanel network connectivity management daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/patchpanel/"
LICENSE="BSD-Google"
KEYWORDS="*"

# These USE flags are used in patchpanel/BUILD.gn
IUSE="fuzzer arcvm"

COMMON_DEPEND="
	dev-libs/protobuf:=
	chromeos-base/metrics:=
	chromeos-base/shill-net:=
	chromeos-base/system_api:=[fuzzer?]
"

RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/shill
	net-dns/dnsmasq
	net-firewall/conntrack-tools
	net-firewall/iptables
	net-misc/bridge-utils
	net-misc/radvd
	sys-apps/iproute2
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/session_manager-client:=
	chromeos-base/shill-client:=
	chromeos-base/system_api:=[fuzzer?]
	chromeos-base/vboot_reference:=
"

patchpanel_header() {
	doins "$1"
	sed -i '/.pb.h/! s:patchpanel/:chromeos/patchpanel/:g' \
		"${D}/usr/include/chromeos/patchpanel/$1" || die
}

src_install() {
	platform_src_install

	"${S}"/preinstall.sh "${PV}" "/usr/include/chromeos" "${OUT}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/libpatchpanel-util.pc

	insinto /usr/include/chromeos/patchpanel/
	patchpanel_header address_manager.h
	patchpanel_header file_descriptor_watcher_posix.h
	patchpanel_header guest_type.h
	patchpanel_header mac_address_generator.h
	patchpanel_header message_dispatcher.h
	patchpanel_header mock_message_dispatcher.h
	patchpanel_header net_util.h
	patchpanel_header socket.h
	patchpanel_header socket_forwarder.h
	patchpanel_header subnet.h
	patchpanel_header subnet_pool.h

	insinto /usr/include/chromeos/patchpanel/dns
	patchpanel_header dns/dns_protocol.h
	patchpanel_header dns/dns_query.h
	patchpanel_header dns/dns_response.h
	patchpanel_header dns/io_buffer.h

	local fuzzer
	for fuzzer in "${OUT}"/*_fuzzer; do
		local fuzzer_component_id="156085"
		platform_fuzzer_install "${S}"/OWNERS "${fuzzer}" \
			--comp "${fuzzer_component_id}"
	done
}

pkg_preinst() {
	# Service account used for privilege separation.
	enewuser patchpaneld
	enewgroup patchpaneld
}

platform_pkg_test() {
	platform test_all
}
