# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4b68ee6824f9d7bc05d394ec75a66e1193885d88"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "d59e71ccef5d54ff0d0d3d41a69aa70d60282d7a" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml_core .gn"

DESCRIPTION="Chrome OS ML Core Feature Library"

PLATFORM_SUBDIR="ml_core"

inherit cros-workon platform

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="internal"

RDEPEND="
	internal? ( chromeos-base/ml-core-internal:= )
"
DEPEND="${RDEPEND}
"

src_install() {
	platform_src_install
	dolib.so "${OUT}"/lib/libcros_ml_core.so
}

platform_pkg_test() {
	platform test_all
}
