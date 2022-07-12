# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="473c4b7c5aa25eaacdd27b48f58a8a6a94b343ca"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "1811069d8336280067e37e916bf8b24942da00cf" "13589065b95265afa465b9bd0a87dde7a58e9481" "98e14b065465da9503e1e0083b78f5b5b59fbefb" "c79649aa86c6e76494520006877c89b38c13feb9")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/jpeg/libjda_test"

inherit cros-camera cros-workon platform

DESCRIPTION="End to end test for JPEG decode accelerator"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="dev-cpp/gtest"

DEPEND="${RDEPEND}
	chromeos-base/cros-camera-libs"

src_install() {
	platform_src_install
	dobin "${OUT}/libjda_test"
}
