# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="39b00c65d09484c8c84e40bc81067a9b4e86d580"
CROS_WORKON_TREE=("bfb6ecc4da4dc2d7aafa35ed314e5d2fb8f2f8a6" "75360a52c58cd825413d38cf390502a37b3b8447" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
