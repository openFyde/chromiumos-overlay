# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="3b111282f1324ec462d705372b441e28f6caefb9"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "56ebaba2bbb985bdfae612ea5533ddf02fdf1548" "97e2f0b1a81d232f739ef5fef9fa68657759387f" "f01918105d4fd88f49e1287e635df4c0f97b9e9b" "dfca03ac1f2edbf642708af0992891cc93024aa8" "0f8162ff9f6ac631d51015788a59900fa1190abd" "589372b673eac2125688c94181c9b91cb1a50f06")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE=".gn camera/build camera/camera3_test camera/common camera/include chromeos-config common-mk"
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
	>=chromeos-base/cros-camera-libs-0.0.1-r34:=
	chromeos-base/cros-camera-android-deps
	media-libs/libexif
	media-libs/libsync
	media-libs/minigbm
	virtual/jpeg:0"

DEPEND="${RDEPEND}
	dev-cpp/gtest:=
	media-libs/libyuv
	virtual/pkgconfig"

src_install() {
	platform_src_install
	dobin "${OUT}/cros_camera_test"
	dolib.so "${OUT}/lib/libfake_date_time.so"
}
