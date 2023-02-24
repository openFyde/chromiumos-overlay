# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="ee11aa653a6e53c49ede4de52ac6f2280f2ffd73"
CROS_WORKON_TREE=("ca7895485a50f354a0c396417657ff67fbbdf40f" "887a35234fe1379635035430f8305f1de93d2075" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
