# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1007e36b0e85b85b2140e91cb52ae9041b6df40f"
CROS_WORKON_TREE=("455da79bcff0fd8f44fbae5ad5e1d23e5ffd09fd" "e49f1116374d651f8c4d7693bd736c1c256ed298" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml_core .gn"

DESCRIPTION="Chrome OS ML Core Feature Library"

PLATFORM_SUBDIR="ml_core"

inherit cros-workon platform

RDEPEND="
"
DEPEND="${RDEPEND}
"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

src_install() {
	platform_src_install
	dolib.so "${OUT}"/lib/libcros_ml_core.so
}

platform_pkg_test() {
	platform test_all
}
