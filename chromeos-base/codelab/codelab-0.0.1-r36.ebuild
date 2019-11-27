# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="df5917bf15f95fdbd23335756c2237feb92ff911"
CROS_WORKON_TREE=("587fcc1fc96e0444ffe553cf04588b83796f3de2" "3b9dd31df2ff711b4cb29425c0ba5510249fa497" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
