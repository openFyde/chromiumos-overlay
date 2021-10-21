# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="249b91d712897cc90fe57dd60d41154c68c1a094"
CROS_WORKON_TREE=("2c293b25dd09e3deae29a0dd7d637fbc1cc44597" "94dfcd3dbd61f0fad7e73b3d224b528ca8cc6fa4" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	dolib.so "${OUT}"/lib/libglib_bridge.so

	# Install headers.
	insinto /usr/include/glib-bridge
	doins *.h

	# Install pc file.
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/obj/glib-bridge/libglib_bridge.pc
}


platform_pkg_test() {
	platform_test "run" "${OUT}/glib_bridge_test_runner"
}
