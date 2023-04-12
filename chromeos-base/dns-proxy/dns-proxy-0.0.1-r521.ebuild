# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1c8aaaaf15c957a5ec44b42ec9a6164dea6e66f0"
CROS_WORKON_TREE=("8fad85aa9518e1a0f04272ae9e077c4a4036297d" "b7d0e192de86a981fbf2db7419e77e181aca910a" "be6b90ece8cba62df98f449a023b1a060f77a3b6" "f74f32e76e5f0463b8473657c06db9cbb493b16a" "5ac59e6f1654fe116d2a29f33679f4439fc40513" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk dns-proxy metrics shill/dbus/client shill/net .gn"

PLATFORM_SUBDIR="dns-proxy"

inherit cros-workon platform user

DESCRIPTION="A daemon that provides DNS proxying services."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dns-proxy/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/metrics:=
	chromeos-base/minijail:=
	chromeos-base/patchpanel:=
	chromeos-base/patchpanel-client:=
	chromeos-base/session_manager-client:=
	chromeos-base/shill-dbus-client:=
	chromeos-base/shill-net:=
	dev-libs/protobuf:=
	dev-libs/dbus-glib:=
	sys-apps/dbus:=
	net-misc/curl:=
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="
	${COMMON_DEPEND}
	chromeos-base/permission_broker-client:=
"

pkg_preinst() {
	enewuser "dns-proxy"
	enewgroup "dns-proxy"
}

src_install() {
	platform_src_install

	dosym /run/dns-proxy/resolv.conf /etc/resolv.conf

	local fuzzer_component_id="156085"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/ares_client_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/doh_curl_client_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/resolver_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
