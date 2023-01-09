# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d5e7d85cb7d8dbc34414e8cc4d0376c65834d546"
CROS_WORKON_TREE=("eb1fe3bef742a865c350a9d742e224d4077efbd5" "85af9f41b089de1995afc6bcaf22a3b96b2232e7" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
IUSE="fuzzer"

DEPEND="
	dev-libs/re2:=
"
RDEPEND="
	!<chromeos-base/shill-0.0.5
"

src_install() {
	platform_src_install

	# Install libshill-net library.
	insinto "/usr/$(get_libdir)/pkgconfig"
	local v="$(libchrome_ver)"
	./preinstall.sh "${OUT}" "${v}"
	dolib.so "${OUT}/lib/libshill-net.so"
	doins "${OUT}/lib/libshill-net.pc"

	# Install header files from libshill-net.
	insinto /usr/include/shill/net
	doins ./*.h

	local platform_network_component_id="167325"
	local platform_wifi_component_id="893827"

	# These each have different listed component ids.
	platform_fuzzer_install "${S}"/../OWNERS "${OUT}/arp_client_fuzzer" \
		--comp "${platform_network_component_id}"
	platform_fuzzer_install "${S}"/../OWNERS "${OUT}/ip_address_fuzzer" \
		--comp "${platform_network_component_id}"
	platform_fuzzer_install "${S}"/../OWNERS "${OUT}/netlink_attribute_list_fuzzer" \
		--comp "${platform_network_component_id}"
	platform_fuzzer_install "${S}"/../OWNERS "${OUT}/nl80211_message_fuzzer" \
		--comp "${platform_wifi_component_id}"
	platform_fuzzer_install "${S}"/../OWNERS "${OUT}/rtnl_handler_fuzzer" \
		--comp "${platform_network_component_id}"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/shill_net_test"
}
