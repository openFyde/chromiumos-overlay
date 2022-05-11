# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="537f425c1897592202be1a89da3b00e9e8776e9b"
CROS_WORKON_TREE=("94ecccaff36fb5fe0d5b36d7df231cdb114ca7d8" "83e237393e2a9f7780805a24d3678c8dbca5bd93" "30ab440fe6d9ae0feadfa95f36c2e3244dbe17c4" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	platform_install

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
