# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bb9afe6773e6b4e0927003b9b85087f875eef03e"
CROS_WORKON_TREE=("017dc03acde851b56f342d16fdc94a5f332ff42e" "0dae02aa901ab30714fc71ae6fcf34f57b5c45cf" "81e06d0b9a5210d30f44449f198d8c6fa7acf299" "e1f223c8511c80222f764c8768942936a8de01e4" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk dlp featured metrics .gn"

PLATFORM_SUBDIR="dlp"

inherit cros-workon libchrome platform user

DESCRIPTION="A daemon that provides support for Data Leak Prevention restrictions for file accesses."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlp/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer"

COMMON_DEPEND="
	chromeos-base/metrics:=
	chromeos-base/minijail:=
	!dev-db/leveldb
	dev-libs/leveldb:=
	dev-libs/protobuf:=
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	chromeos-base/featured:=
	chromeos-base/session_manager-client:=
	chromeos-base/system_api:=
	sys-apps/dbus:=
	fuzzer? ( dev-libs/libprotobuf-mutator:= )
"

src_install() {
	platform_src_install

	local daemon_store="/etc/daemon-store/dlp"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners dlp:dlp "${daemon_store}"

	local fuzzer_component_id="892101"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/dlp_adaptor_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	local gtest_filter_user_tests="-*.RunAsRoot*:"
	local gtest_filter_root_tests="*.RunAsRoot*-"

	platform_test "run" "${OUT}/dlp_test" "0" "${gtest_filter_user_tests}"
	platform_test "run" "${OUT}/dlp_test" "1" "${gtest_filter_root_tests}"
}

pkg_setup() {
	enewuser "dlp"
	enewgroup "dlp"
	cros-workon_pkg_setup
}
