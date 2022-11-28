# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="8f5e2ee4025e182b99c5e6181a0a2fe31239c14c"
CROS_WORKON_TREE=("7c7d4170b01f9cd05a107c251a378c716ccd9d77" "083569b82e5bcbfefd8700a2cd52ea619e712f7a" "01f04b72ed9243b576ef00f1e519c5e9d2b5883b" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
