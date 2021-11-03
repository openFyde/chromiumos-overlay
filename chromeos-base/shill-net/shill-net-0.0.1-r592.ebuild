# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b31a9b728432f39e3e203a157099247d6bb82b33"
CROS_WORKON_TREE=("0d4ecaca2c9246b7d0f0fd9aa952cc67b495b596" "6fb485c531f7f01d3e8f7b28b759bd55074d69a0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk shill .gn"

PLATFORM_SUBDIR="shill/net"

inherit cros-workon platform

DESCRIPTION="Shill networking component interface library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/shill/net"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="fuzzer +wifi"

DEPEND=""
RDEPEND="
	!<chromeos-base/shill-0.0.5
"

src_install() {
	# Install libshill-net library.
	insinto "/usr/$(get_libdir)/pkgconfig"
	local v="$(libchrome_ver)"
	./preinstall.sh "${OUT}" "${v}"
	dolib.so "${OUT}/lib/libshill-net.so"
	doins "${OUT}/lib/libshill-net.pc"

	# Install header files from libshill-net.
	insinto /usr/include/shill/net
	doins ./*.h

	# These each have different listed component ids.
	local arp_client_fuzzer_component_id="167325"
	platform_fuzzer_install "${S}"/../OWNERS "${OUT}/arp_client_fuzzer" \
		--comp "${arp_client_fuzzer_component_id}"
	local nl80211_message_fuzzer_component_id="893827"
	platform_fuzzer_install "${S}"/../OWNERS "${OUT}/nl80211_message_fuzzer" \
		--comp "${nl80211_message_fuzzer_component_id}"
	local rtnl_handler_fuzzer_component_id="156085"
	platform_fuzzer_install "${S}"/../OWNERS "${OUT}/rtnl_handler_fuzzer" \
		--comp "${rtnl_handler_fuzzer_component_id}"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/shill_net_test"
}
