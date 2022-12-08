# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="20c502d00e253a2d6731ef7563174a6c84f1f599"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "2d0abd098ee0a709b476a33627d483917ed20c58" "38d7e8f3a67c14718619b826697df434baffdf3c" "6a8f34f4be354c892367bc7cd59ebe096de76b7e" "284f3602420093498b1e01984a0db1190bd55812" "9da4303fca3d31774ff2a0ed56ad7e4beb63abc7" "478fda65401c49d9a8814ddd694a79ed5e1ba4f4" "4df47d415ac1886470fe675226dd5a2fcac9f6b9" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk chromeos-config hardware_verifier libec libmems metrics mojo_service_manager rmad .gn"

PLATFORM_SUBDIR="rmad"

inherit cros-workon cros-unibuild platform tmpfiles user

DESCRIPTION="ChromeOS RMA daemon."
HOMEPAGE=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cr50_onboard iioservice ti50_onboard"

COMMON_DEPEND="
	chromeos-base/chromeos-config-tools:=
	chromeos-base/minijail:=
"

RDEPEND="
	${COMMON_DEPEND}
	cr50_onboard? ( chromeos-base/chromeos-cr50 )
	ti50_onboard? ( chromeos-base/chromeos-ti50 )
	chromeos-base/iioservice
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
	chromeos-base/vboot_reference:=
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
