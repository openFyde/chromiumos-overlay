# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="cfa1f5868edaf9109c1c5bab7cbda37f6c8ce802"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "bdce8a305b6af438503ba12680e7d8526bcc2dfc" "1ab12eb0eb36de7f5eefdd18c552cdf9ebda4232" "080361d5d45e74e7927e56bab774531748d1a569" "945578e86a0ba4f2fd2f15f9b368a26a919b3d4d")
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
