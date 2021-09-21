# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6190dde350a94b08f452a5375f220b72671d7837"
CROS_WORKON_TREE=("a3d79a5641e6cda7da95a9316f5d29998cc84865" "adc41790bd30cad5ee6238f35398767f5f85ff7a" "4d2e1d4db5c53f56a391d3d5aea8633969138b9a" "012e2b6adf17921abac48525d15be4a10ec14fda" "5ba31d08afef3018a37bf85333b66d3cb495c743" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Remove libmems from this list.
CROS_WORKON_SUBTREE="common-mk chromeos-config iioservice mems_setup libmems .gn"

PLATFORM_SUBDIR="mems_setup"

inherit cros-workon platform udev

DESCRIPTION="MEMS Setup for Chromium OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/mems_setup"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="generated_cros_config iioservice unibuild"

COMMON_DEPEND="
	chromeos-base/libmems:=
	net-libs/libiio:=
	dev-libs/re2:=
	unibuild? (
		!generated_cros_config? ( chromeos-base/chromeos-config )
		generated_cros_config? ( chromeos-base/chromeos-config-bsp:= )
	)
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:="

src_install() {
	udev_dorules 99-mems_setup.rules
	dosbin "${OUT}"/mems_setup
}

platform_pkg_test() {
	local tests=(
		mems_setup_testrunner
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
