# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="9a2de0d377fdae131802e2c260721d2203d78009"
CROS_WORKON_TREE=("eaed4f3b0a8201ef3951bf1960728885ff99e772" "836d1d444a0f91c853b8bd0e34f8d9a9b8d4444b" "eea2e633994c182e5ec4bfdf540f6593d8da8fa8" "f834b2ebf8881112b6c0a9f042c5db5dec41eca2" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Remove libmems from this list.
CROS_WORKON_SUBTREE="common-mk iioservice mems_setup libmems .gn"

PLATFORM_SUBDIR="mems_setup"

inherit cros-workon platform

DESCRIPTION="MEMS Setup for Chromium OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/mems_setup"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="iioservice"

COMMON_DEPEND="
	chromeos-base/libmems:=
	net-libs/libiio:="

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:="

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
