# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e2ae0b1627d081187ae2cb21c1b76663a1d9eab4"
CROS_WORKON_TREE=("52a8a8b6d3bbca5e90d4761aa308a5541d52b1bb" "7b5886413278a82efc9726fe8d06e9e246f3f07a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk minios .gn"

PLATFORM_SUBDIR="minios"

inherit cros-workon platform

DESCRIPTION="The miniOS main logic."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/minios/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="minios"
REQUIRED_USE="minios"

RDEPEND=""
DEPEND=""

platform_pkg_test() {
	platform_test "run" "${OUT}/minios_test"
}

src_install() {
	dobin "${OUT}/minios"
}
