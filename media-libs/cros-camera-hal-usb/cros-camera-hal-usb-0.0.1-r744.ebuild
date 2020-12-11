# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="18251f9fcb5317db6f3578c1ddbc01c53bef1686"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "da7b73732df1f454a05ffc3efe5a90d416295e3f" "33af14dee8d39c8e5b1ab60b776257b3dd3169f7" "4a915605af1cd7e632f8e36813007c5403431db2" "a661abd7c4e459764c10f7e466ee615f8c8f0cee" "2442a4f39e2f73fa5881ba4f18d18788df6acf79" "55a053946ecf9046be3a1b4d15127d60bd62af73" "853e56035ddc8eed8fe55176525594404096a0c2")
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
	>=chromeos-base/metrics-0.0.1-r3152
	media-libs/cros-camera-android-headers
	media-libs/libyuv
	virtual/pkgconfig"

src_install() {
	platform_src_install
	cros-camera_dohal "${OUT}/lib/libcamera_hal.so" usb.so
	udev_dorules udev/99-usbcam.rules
}
