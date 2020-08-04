# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="3bedb01f0bbf8767db84c3dace0a1a126ce304b5"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "e8361dab54d0d6fb2cd71f388b8d47e0b58cf5b1" "8b5d3b3ea1e9aaaeb591935487dedb6c05917fe3" "d08b0de17491f94bdaf6aa7564df6f074fb18383" "84441b28a7584715021e2faf292e0cf5864ea8bf" "958af77198c05e4c7d3a5b742487f27ed3d8427b" "d66915ca353c66057a35f8c816bb78c9771bfaa0" "297e1fd56d8076b25efe97f87d1941af1ecbbb59")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/usb camera/include camera/mojo chromeos-config common-mk metrics"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/usb"
CROS_CAMERA_TESTS=(
	"image_processor_test"
)

inherit cros-camera cros-workon platform udev

DESCRIPTION="Chrome OS USB camera HAL v3."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="usb_camera_monocle generated_cros_config unibuild"

RDEPEND="
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
	media-libs/libsync
	unibuild? (
		!generated_cros_config? ( chromeos-base/chromeos-config )
		generated_cros_config? ( chromeos-base/chromeos-config-bsp )
	)
	chromeos-base/chromeos-config-tools"

DEPEND="${RDEPEND}
	chromeos-base/metrics
	media-libs/cros-camera-android-headers
	media-libs/libyuv
	virtual/pkgconfig"

src_install() {
	cros-camera_dohal "${OUT}/lib/libcamera_hal.so" usb.so
	udev_dorules udev/99-usbcam.rules
}
