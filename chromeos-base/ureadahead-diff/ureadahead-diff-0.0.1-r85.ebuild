# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ce76df5e27813421ef09e122cd4a5fe9e8201e3b"
CROS_WORKON_TREE=("3e460a1cdb177bcebbb5ba7ad77043b23d5f5a65" "a3eac5d15a46a63784099b3fe4af44a89d376a6f" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
