# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="36aed02287a4bdf1a99340f77bf00891c7d5a551"
CROS_WORKON_TREE=("0d8a167e372a74ff40cff24fdc7d47644590bb7e" "27c04f7107e3a9ba51e73eccef6fce1443198f6d" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk glib-bridge .gn"

PLATFORM_SUBDIR="glib-bridge"

inherit cros-workon platform

DESCRIPTION="libchrome-glib message loop bridge"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/glib-bridge"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	dev-libs/glib:="

DEPEND="${RDEPEND}"

src_install() {
	platform_src_install

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
	platform_test "run" "${OUT}/glib_structured_logger_test_runner"
	platform_test "run" "${OUT}/glib_unstructured_logger_test_runner"
}
