# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d6d039500516434425e66edc3b63fac1e8eb1ffc"
CROS_WORKON_TREE=("aaaaa3f7d8b4455b36eba6a9874fca10fefb836c" "2f85247341c3383d9d02d2c7b56ca7a4be531aa2" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk ureadahead-diff .gn"

PLATFORM_SUBDIR="ureadahead-diff"

inherit cros-workon platform

DESCRIPTION="Calculate common part and difference of two ureadahead packs"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/ureadahead-diff"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

src_install() {
	platform_src_install

	dobin "${OUT}"/ureadahead-diff
}

platform_pkg_test() {
	platform_test "run" "${OUT}/ureadahead-diff_testrunner"
}
