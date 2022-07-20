# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0838dd8cb7238027a16743d7eb0c8e29de1df369"
CROS_WORKON_TREE=("4055d34d682d2a7ff6bc4285499301674c0779ab" "54387be4d63a0f719803fe24004faa4412171c65" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
