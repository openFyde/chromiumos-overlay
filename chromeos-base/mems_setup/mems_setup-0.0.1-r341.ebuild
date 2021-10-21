# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="249b91d712897cc90fe57dd60d41154c68c1a094"
CROS_WORKON_TREE=("2c293b25dd09e3deae29a0dd7d637fbc1cc44597" "3a8b816b9fdaca04ec76e8a8d97b206e139a9dfc" "24c091aa492affb9bb6e83be5bcbac5fddb452e0" "37e96794a4141d0a9af6eb1561df2ea8d8a6202f" "c499b2973c37d54ec7bf94f3a4e634e8642e6193" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Remove libmems from this list.
CROS_WORKON_SUBTREE="common-mk chromeos-config iioservice mems_setup libmems .gn"

PLATFORM_SUBDIR="mems_setup"

inherit cros-workon cros-unibuild platform udev

DESCRIPTION="MEMS Setup for Chromium OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/mems_setup"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="iioservice"

COMMON_DEPEND="
	chromeos-base/libmems:=
	net-libs/libiio:=
	dev-libs/re2:=
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
