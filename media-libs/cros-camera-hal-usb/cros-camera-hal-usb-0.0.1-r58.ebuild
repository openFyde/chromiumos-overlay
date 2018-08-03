# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("39f05742a22dad69a5b2b0aabccc219ba00990f0" "cd758dcfa26a892a9051b2c0a90bc445aeb8a06e")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "d9bb358e0de30566e67b7c195127280c59f59cfc" "7db7e0f493ad0b47165e64d5c78cf43c560326cc" "f76158d0e16c8033308464a79a91fc0165d07fc8")
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
	"build hal/usb include"
	"common-mk"
)
PLATFORM_GYP_FILE="hal/usb/libcamera_hal.gyp"
CROS_CAMERA_TESTS=(
	"image_processor_unittest"
)

inherit cros-camera cros-workon

DESCRIPTION="Chrome OS USB camera HAL v3."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
RDEPEND="
	chromeos-base/libbrillo
	dev-libs/re2
	!media-libs/arc-camera3-hal-usb
	media-libs/cros-camera-libcamera_client
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_exif
	media-libs/cros-camera-libcamera_jpeg
	media-libs/cros-camera-libcamera_metadata
	media-libs/cros-camera-libcamera_timezone
	media-libs/cros-camera-libcbm
	media-libs/cros-camera-libjda
	media-libs/libsync"

DEPEND="${RDEPEND}
	media-libs/cros-camera-android-headers
	media-libs/libyuv
	virtual/pkgconfig"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	cros-camera_dohal "${OUT}/lib/libcamera_hal.so" usb.so
}
