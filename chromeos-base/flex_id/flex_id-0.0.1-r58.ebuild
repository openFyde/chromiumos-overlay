# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="dbb1136242ba822d539eaf11493f3b68815adb7f"
CROS_WORKON_TREE=("60fa47aebd6ebfb702012849bd560717fceddcd4" "c5a49444cc51d4d5d217c797f33502ff7e8a3dbc" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk flex_id .gn"

PLATFORM_SUBDIR="flex_id"

inherit cros-workon platform

DESCRIPTION="Utility to generate Flex ID for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/flex_id"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="!chromeos-base/client_id"

src_install() {
	dobin "${OUT}"/flex_id_tool
}

platform_pkg_test() {
	platform_test "run" "${OUT}/flex_id_test"
}
