# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4214b5f961cea8951ab83e7dedfb931e99d08e79"
CROS_WORKON_TREE=("8ff1eab586712c03641dda82a1877dfc4cd6eb72" "73e12f70fea9bf3d370e357f77a1d960057d8a43" "103d47ce122d5311ae046e21326b5ff7dcb7a1c9" "53e4f1efe7425738800f489540ac9dce1a0b3522" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	net-firewall/iptables
	net-misc/bridge-utils
	sys-apps/iproute2
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/session_manager-client:=
	chromeos-base/shill-client:=
	chromeos-base/system_api:=[fuzzer?]
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
