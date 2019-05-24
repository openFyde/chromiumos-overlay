# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="5e04a5edbd9cb77b99dfae6d9f135a8c8f989c68"
CROS_WORKON_TREE=("0b59dbfa6eda71d101f7be5cc518450e4b5d1be4" "9cc4bb9fe5cf6e7d761091a66dbb532b11f7d0d9" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk mems_setup .gn"

PLATFORM_SUBDIR="mems_setup"

inherit cros-workon platform

DESCRIPTION="MEMS Setup for Chromium OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/mems_setup"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="net-libs/libiio:="

DEPEND="${RDEPEND}
	chromeos-base/system_api"

src_install() {
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
