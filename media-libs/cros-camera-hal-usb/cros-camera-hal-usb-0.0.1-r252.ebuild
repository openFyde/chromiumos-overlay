# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="3d821723419aa892be416ea05fd1ec6269f4c604"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "7134e391e4c04513211b250b665951820d5b0bbd" "9340d944ab1cac8449c6402218fed53b68086859" "f8d409d5a01026794b39419baac49012a2f4dba5" "d91d17d55ce741e7cbd075983d30b0e5c1be4c84" "79935d3039bad820fa03c8bded635ad197ad74ab" "f577121f2538fbe78584b4fe59c478a26bf80df4" "11f6aaa2391d33bf71589db668ed50eeacfcb461")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/usb camera/include camera/mojo common-mk metrics"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="hal/usb/libcamera_hal.gyp"
CROS_CAMERA_TESTS=(
	"image_processor_unittest"
)

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS USB camera HAL v3."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="usb_camera_monocle"

RDEPEND="
	chromeos-base/libbrillo
	dev-libs/re2
	!media-libs/arc-camera3-hal-usb
	media-libs/cros-camera-libcamera_client
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_exif
	media-libs/cros-camera-libcamera_metadata
	usb_camera_monocle? ( media-libs/librealtek-sdk )
	media-libs/cros-camera-libcamera_timezone
	media-libs/cros-camera-libcbm
	media-libs/cros-camera-libjda
	media-libs/libsync"

DEPEND="${RDEPEND}
	chromeos-base/metrics
	media-libs/cros-camera-android-headers
	media-libs/libyuv
	virtual/pkgconfig"

src_install() {
	cros-camera_dohal "${OUT}/lib/libcamera_hal.so" usb.so
}
