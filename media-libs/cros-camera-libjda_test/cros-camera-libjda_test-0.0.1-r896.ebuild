# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="e62d61566ab4141d37bd08aa2614dc1e5b1ed273"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "fb991ada697f993a8282997d62671c49daef274f" "7e58eaa2e768ae8112ab3b362a1d789a1f73e78e" "0c3a30cd50ce72094fbd880f2d16d449139646a2")
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
