# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5d9e35b8aed6e1af82447620cd2dfb0102e5a7b1"
CROS_WORKON_TREE=("a1485b27500f3f8a7cf4204d77b152d1c173e313" "56dc9b3a788bc68f829c1e7a1d3b6cf067c7aaf9" "47e08d746e33c555317ae5a3c41f75d09c94ad07" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libpasswordprovider system-proxy .gn"

PLATFORM_SUBDIR="system-proxy"

inherit cros-workon platform user

DESCRIPTION="A daemon that provides authentication support for system services
and ARC apps behind an authenticated web proxy."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/system-proxy/"

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
