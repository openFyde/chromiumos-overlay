# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="995e10579fafb6499d3e0da33c6b5acc011118e0"
CROS_WORKON_TREE=("36bc32d34cdd5a8aa796661ad9ca401b99c7f218" "5acd27d64424cdfee7ed6c6abd3e4310e2ad4687" "32b01675a699325361df67452789542c5eb5024a" "1daf1bea13a1b789cef5c1b857a8dc4058f20ffb" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
