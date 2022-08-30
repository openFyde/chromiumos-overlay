# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="f2f6b8108a332ff756fa190bb1bba54b09c7e217"
CROS_WORKON_TREE=("9cddaab94373bf5cc18d0c29b52822676e80d756" "0bb4f1d027f4fd2368775ade6c2d929e5773cdf8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk codelab .gn"

CROS_WORKON_OUTOFTREE_BUILD="1"

PLATFORM_SUBDIR="codelab"

inherit cros-workon platform

DESCRIPTION="Developer codelab for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/codelab/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

src_install() {
	platform_src_install

	dobin "${OUT}"/codelab
}

platform_pkg_test() {
	platform_test "run" "${OUT}/codelab_test"
}
