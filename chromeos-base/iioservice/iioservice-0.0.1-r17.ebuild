# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="300292b66ec823232b046d9ee4fb24a5fc7d98fc"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "23d1194854d391eac0fa0c8901f8eefa85dd34c7" "17ef7f8b78d237d55aed891b757c1c7397e9380e" "a18be0e4067223084eb001e588d475448d48cd4c")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
# TODO(crbug.com/809389): Remove libmems from this list.
CROS_WORKON_SUBTREE=".gn iioservice libmems common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="iioservice/daemon"

inherit cros-workon platform

DESCRIPTION="Chrome OS sensor HAL IPC util."

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libiioservice_ipc:=
	chromeos-base/libmems:=
"

DEPEND="${RDEPEND}
	chromeos-base/system_api:=
"

src_install() {
	dosbin "${OUT}"/iioservice
}

platform_pkg_test() {
	local tests=(
		iioservice_testrunner
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
