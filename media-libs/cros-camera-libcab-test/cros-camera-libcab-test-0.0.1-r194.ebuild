# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="269215d09a26f380b2835aa3ea45a69d87e64b47"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "9070f9f3e25e1440437a8814ac08615f3d9f8be4" "2624ca1aeb7f546093c8cac8244297955cb1481d" "88964300c225b7e8a3c2fe47860d091ca1f4fb65")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="common/libcab_test.gyp"

inherit cros-camera cros-workon platform

DESCRIPTION="Test for camera algorithm bridge library"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	dev-cpp/gtest
	!media-libs/arc-camera3-libcab-test
	media-libs/cros-camera-libcab"

DEPEND="${RDEPEND}"

src_install() {
	dobin "${OUT}/libcab_test"
	dolib.so "${OUT}/lib/libcam_algo.so"
}
