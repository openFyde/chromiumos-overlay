# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="8d996397d3d660327d2123dca8efdeeeadd01711"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "75b8ec01f4927720e636bf5b66a654dfebaf1afb" "741f8452f96fa388f2ddca6b4c937979b52e9ae5" "25b898600df49f492605ef9c977f7948684c01bb" "a661abd7c4e459764c10f7e466ee615f8c8f0cee" "f86b3dad942180ce041d9034a4f5f9cceb8afe6b")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/camera3_test camera/common camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/camera3_test"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera HAL native test."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"

RDEPEND="
	!media-libs/arc-camera3-test
	media-libs/cros-camera-libcamera_client
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_metadata
	media-libs/cros-camera-libcbm
	media-libs/libexif
	media-libs/libsync
	media-libs/minigbm
	virtual/jpeg:0"

DEPEND="${RDEPEND}
	dev-cpp/gtest:=
	media-libs/cros-camera-android-headers
	media-libs/libyuv
	virtual/pkgconfig"

src_install() {
	platform_src_install
	dobin "${OUT}/cros_camera_test"
}
