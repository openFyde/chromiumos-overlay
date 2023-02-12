# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f95d5c29a61052bff60db6d1151db2ebb7b4abcd"
CROS_WORKON_TREE=("f6e687d95778aff2f019e7bfb54e40255774136d" "27ed0e5d9498c23e1dac7d35e68a8cd10de86de6" "df8645a6dc39ee0ef0a05723a1b23bfacf27d16f" "6df1cbd56008025f75967252b37c51cf894558cb" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
