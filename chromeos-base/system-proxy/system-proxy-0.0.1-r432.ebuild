# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f5905cb27d9b5dbf6bf6e338cf012ba9267a0523"
CROS_WORKON_TREE=("4d05be6aacce39f0ffed0cb00fc7d88926121b65" "083569b82e5bcbfefd8700a2cd52ea619e712f7a" "4dab27d30997630c56113b3d12f926178b1e8f14" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libpasswordprovider system-proxy .gn"

PLATFORM_SUBDIR="system-proxy"

inherit cros-workon platform user

DESCRIPTION="A daemon that provides authentication support for system services
and ARC apps behind an authenticated web proxy."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/system-proxy/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="fuzzer"

COMMON_DEPEND="
	chromeos-base/libpasswordprovider:=
	chromeos-base/minijail:=
	chromeos-base/patchpanel:=
	chromeos-base/patchpanel-client:=
	dev-libs/protobuf:=
	sys-apps/dbus:=
	net-misc/curl:=
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="
	${COMMON_DEPEND}
	chromeos-base/permission_broker-client:=
	fuzzer? ( dev-libs/libprotobuf-mutator:= )
"

pkg_preinst() {
	enewuser "system-proxy"
	enewgroup "system-proxy"
}

src_install() {
	platform_src_install

	if use fuzzer; then
		local fuzzer_component_id="156085"
		platform_fuzzer_install "${S}"/OWNERS "${OUT}"/system_proxy_connect_headers_parser_fuzzer \
			--comp "${fuzzer_component_id}"
		platform_fuzzer_install "${S}"/OWNERS "${OUT}"/system_proxy_worker_config_fuzzer \
			--comp "${fuzzer_component_id}"
		platform_fuzzer_install "${S}"/OWNERS "${OUT}"/system_proxy_http_util_fuzzer \
			--comp "${fuzzer_component_id}"
	fi
}

platform_pkg_test() {
	platform test_all
}
