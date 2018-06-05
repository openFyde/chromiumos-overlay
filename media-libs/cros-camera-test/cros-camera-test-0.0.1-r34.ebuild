# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("0a118b4b802470be9575762446cf0d5c41f306f4" "adac8fc6ca32bc376332d316872a85b068d4d232")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "47a71cd5bdc52e8f786cda94b60325eca0437d9e" "ad6705ef10f3a1ddcc06ad5623f8d67ab0599ca9" "6dd24c3358b82474c558c65a0d6e0d3f3d9193c4")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/arc-camera"
	"chromiumos/platform2"
)
CROS_WORKON_LOCALNAME=(
	"../platform/arc-camera"
	"../platform2"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/arc-camera"
	"${S}/platform2"
)
CROS_WORKON_SUBTREE=(
	"build camera3_test common"
	"common-mk"
)
PLATFORM_GYP_FILE="camera3_test/cros_camera_test.gyp"

inherit cros-camera cros-workon

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
	dev-cpp/gtest
	media-libs/cros-camera-android-headers
	media-libs/libyuv
	virtual/pkgconfig"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dobin "${OUT}/cros_camera_test"
}
