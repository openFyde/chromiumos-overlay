# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2d3c06e5121ad1c5b08207ae0b2ed34d993916ca"
CROS_WORKON_TREE=("d4c46f75f6620ba5bf8f25c12db0b85b5839ea54" "31cdfcb63fd7f2173854b108428f572e4f029b93" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
