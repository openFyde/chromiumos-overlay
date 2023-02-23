# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="27e629bce33cf4b9adfd72353e7b1205ced202c9"
CROS_WORKON_TREE=("55939c6ae7e4e501ab2d3534ef3c746607fcc2cd" "e1f223c8511c80222f764c8768942936a8de01e4" "1664fac460ddde3410d810389d8b60c493264d8f" "8b7e4fdec7193f5c2556a905e8137dd3f3bada6a" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk metrics patchpanel shill/net .gn"

PLATFORM_SUBDIR="patchpanel"
# Tests use /dev/net/tun.
PLATFORM_HOST_DEV_TEST="yes"

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

	# Main binary.
	dobin "${OUT}"/patchpaneld

	# Libraries.
	dolib.so "${OUT}"/lib/libpatchpanel-util.so

	"${S}"/preinstall.sh "${PV}" "/usr/include/chromeos" "${OUT}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/libpatchpanel-util.pc

	insinto /usr/include/chromeos/patchpanel/
	patchpanel_header address_manager.h
	patchpanel_header guest_type.h
	patchpanel_header mac_address_generator.h
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

	insinto /etc/init
	doins "${S}"/init/patchpanel.conf

	insinto /etc/dbus-1/system.d
	doins dbus/*.conf

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
	platform_test "run" "${OUT}/patchpanel_testrunner"
}
