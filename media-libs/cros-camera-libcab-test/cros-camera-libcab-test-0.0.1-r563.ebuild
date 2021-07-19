# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="f46fab9263082e584015f88a5a820ce468a47892"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "a9db923ed9d7e66024405ab4fdb8bbe178930040" "a8c513bdec7e28398369b42aef91977c2e9be0f6" "334c8e0caef41ce68b04849338004bd466bd75a5" "cc8ae75ea68e5c37c867b396c0540c8a109ed460")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcab_test"

inherit cros-camera cros-workon platform

DESCRIPTION="Test for camera algorithm bridge library"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/cros-camera-libs
	dev-cpp/gtest:="

DEPEND="${RDEPEND}"

src_install() {
	dobin "${OUT}/libcab_test"
	dolib.so "${OUT}/lib/libcam_algo_test.so"
}
