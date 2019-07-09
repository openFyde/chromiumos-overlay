# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="8d4c29513c43a3d2203505da2d95653c45bec45b"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "7134e391e4c04513211b250b665951820d5b0bbd" "e1c3f72095079c5cb59322a07192c8faf2a9b15c" "2624ca1aeb7f546093c8cac8244297955cb1481d" "79935d3039bad820fa03c8bded635ad197ad74ab" "dee870e424cb9c2bf83477e685ba64450a5b16f3")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="common/jpeg/libjea_test.gyp"

inherit cros-camera cros-workon platform

DESCRIPTION="End to end test for JPEG encode accelerator"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	dev-cpp/gtest:=
	media-libs/cros-camera-libcamera_exif"

src_install() {
	dobin "${OUT}/libjea_test"
}

