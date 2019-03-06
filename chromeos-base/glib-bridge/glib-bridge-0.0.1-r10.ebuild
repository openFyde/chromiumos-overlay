# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="ea4848dddea32f8b28e02d8d4fea34cad3ae6d45"
CROS_WORKON_TREE=("e220eed9c62e23a855f6b5ebce2310a69a9309a5" "5f28ce40c115146c29ca4b4f248e4dc5220833b8" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk glib-bridge .gn"

PLATFORM_SUBDIR="glib-bridge"

inherit cros-workon platform

DESCRIPTION="libchrome-glib message loop bridge"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/glib-bridge"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	dev-libs/glib:="

DEPEND="${RDEPEND}"

src_install() {
	dolib.a "${OUT}"/libglib_bridge.a
}


platform_pkg_test() {
	platform_test "run" "${OUT}/glib_bridge_test_runner"
}
