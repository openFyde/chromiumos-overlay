# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("36041bbdb99f49dfa60d1337684428ee536125a7" "45ebdc7d36c2cd451d5936d300b816aafc928a1a")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "6028cd9188022931b0d2737a1d688fec44e3078b" "3689ecf6b9e4d59cad6c442cff58b0664eefc4c2" "f62010221e3eb0566f97bc9fe74a5d47808c8cc4" "5d76066514dca6a32e833620a997a659f7fb2fd0")
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
	"build common hal/usb include"
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
