# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="82e2427db9e8d9e6131685a4750cd1a657eb5fdc"
CROS_WORKON_TREE=("0f4044624c1fabe638a8289e62ec74756aa62176" "f975efb62969c0c82cc22449ea17a0c2e54ef025" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
