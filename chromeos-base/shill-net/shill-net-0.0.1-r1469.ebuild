# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="98c0988cb06f378daf97ca559e809ee5a5c029ef"
CROS_WORKON_TREE=("e44d7e66ab4ccaab888a42ade972724af9621706" "3aad290a01fc31020e4573e4aea2a96dcc3b6db8" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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

	# Generate and install libshill-net pkgconfig.
	insinto "/usr/$(get_libdir)/pkgconfig"
	local v="$(libchrome_ver)"
	./preinstall.sh "${OUT}" "${v}"
	doins "${OUT}/lib/libshill-net.pc"

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
	platform test_all
}
