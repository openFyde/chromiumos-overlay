# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="88586672d6aa6e654cf8691b56a3e88e8f422e6a"
CROS_WORKON_TREE=("f834e7e40228b458c4100226f262117a9d85cdb3" "59a4c1e8ec4bfd1a47f34b007aee2d32d187d84d" "6520bb92d189d85114c0e8ea36fb8467382f8a6f" "3d518da1ff6fb97aedeff8b1eabe2bf4a79dba30" "5b28008ef57b80321ffa3c70657574c1da17f8b9" "9edcaccb998f9f1dac82dd862beddc2491e8ab68" "6df1cbd56008025f75967252b37c51cf894558cb" "73889d0041bcd8e88b0b6d54e8d40eb99eaac094" "daa41bdaab39dd476f9d8f76e9366b4971ef0704" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk chromeos-config hardware_verifier iioservice libec libmems metrics mojo_service_manager rmad .gn"

# Tests use /dev/loop*.
PLATFORM_HOST_DEV_TEST="yes"
PLATFORM_SUBDIR="rmad"

inherit cros-workon cros-unibuild platform tmpfiles user

DESCRIPTION="ChromeOS RMA daemon."
HOMEPAGE=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cr50_onboard ti50_onboard"

COMMON_DEPEND="
	chromeos-base/chromeos-config-tools:=
	chromeos-base/minijail:=
"

RDEPEND="
	${COMMON_DEPEND}
	cr50_onboard? ( chromeos-base/chromeos-cr50 )
	ti50_onboard? ( chromeos-base/chromeos-ti50 )
	chromeos-base/croslog
	chromeos-base/hardware_verifier
	chromeos-base/libmems
	chromeos-base/runtime_probe
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/cryptohome-client:=
	chromeos-base/libec:=
	chromeos-base/libiioservice_ipc:=
	chromeos-base/metrics:=
	chromeos-base/mojo_service_manager:=
	chromeos-base/runtime_probe-client:=
	chromeos-base/shill-client:=
	chromeos-base/system_api:=
	chromeos-base/tpm_manager-client:=
"

pkg_preinst() {
	# Create user and group for RMA.
	enewuser "rmad"
	enewgroup "rmad"
}

src_install() {
	platform_src_install

	dotmpfiles tmpfiles.d/*.conf
}

platform_pkg_test() {
	local gtest_filter_user_tests="-*RunAsRoot*"
	local gtest_filter_root_tests="*RunAsRoot*-"

	platform_test "run" "${OUT}/rmad_test" "0" "${gtest_filter_user_tests}"
	platform_test "run" "${OUT}/rmad_test" "1" "${gtest_filter_root_tests}"
}
