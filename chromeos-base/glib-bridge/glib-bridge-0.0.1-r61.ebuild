# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="c6e430949b7789fd1155da1ce6451cc5c30f2555"
CROS_WORKON_TREE=("3ec7544c4b108a15d3ea61facc0a4bbeace58eed" "e5523a0b9b5d93d50ebd806f14f4544e7275d829" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

	# Install headers.
	insinto /usr/include/glib_bridge
	doins *.h
}


platform_pkg_test() {
	platform_test "run" "${OUT}/glib_bridge_test_runner"
}
