# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="d90d18f14d9acb5f7de71431ca2ed45275821539"
CROS_WORKON_TREE=("b050a2ab2836dd6da5e48eab3fd4ac328d4325bc" "33e5aca12c86f00e0c8a3deaf42b9e649eed52a3" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk codelab .gn"

PLATFORM_SUBDIR="codelab"

inherit cros-workon platform

DESCRIPTION="Developer codelab for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/codelab/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

src_install() {
	dobin "${OUT}"/codelab
}

platform_pkg_test() {
	platform_test "run" "${OUT}/codelab_test"
}
