# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="8f838ec0a72fb54554f8057fe425c428e91c80a2"
CROS_WORKON_TREE=("a049deba38a69414f9446279b569687189508f53" "cd7ed28a72e9d26f51890cf74af3f10c6c081f9a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk ureadahead-diff .gn"

PLATFORM_SUBDIR="ureadahead-diff"

inherit cros-workon platform

DESCRIPTION="Calculate common part and difference of two ureadahead packs"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/ureadahead-diff"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

src_install() {
	dobin "${OUT}"/ureadahead-diff
}

platform_pkg_test() {
	platform_test "run" "${OUT}/ureadahead-diff_testrunner"
}
