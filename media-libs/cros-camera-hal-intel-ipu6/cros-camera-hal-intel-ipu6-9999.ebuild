# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/intel/ipu6 camera/include camera/mojo chromeos-config common-mk metrics"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/intel/ipu6"

inherit cros-camera cros-workon platform udev

DESCRIPTION="Intel IPU6 (Image Processing Unit) Chrome OS camera HAL"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~*"
IUSE="ipu6se ipu6ep"

RDEPEND="
	chromeos-base/chromeos-config-tools
	chromeos-base/metrics
	dev-libs/expat
	!ipu6se? ( !ipu6ep? ( media-libs/intel-ipu6-libs-bin ) )
	ipu6se? (
		media-libs/intel-ipu6se-libs-bin
		x11-libs/libva-intel-media-driver
	)
	ipu6ep? ( media-libs/intel-ipu6ep-libs-bin )
	!media-libs/cros-camera-hal-intel-ipu6-squash
	media-libs/cros-camera-libcamera_client
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_exif
	media-libs/cros-camera-libcamera_metadata
	media-libs/cros-camera-libcamera_v4l2_device
	media-libs/cros-camera-libcbm
	media-libs/libsync
	media-libs/libyuv
"

DEPEND="${RDEPEND}
	media-libs/cros-camera-libcab
	sys-kernel/linux-headers
	media-libs/cros-camera-android-headers
	virtual/jpeg:0
	virtual/pkgconfig"

src_install() {
	dolib.so "${OUT}/lib/libcamhal.so"
	cros-camera_dohal "${OUT}/lib/libcamhal.so" intel-ipu6.so
	dolib.so "${OUT}/lib/libcam_algo.so"

	if use ipu6se; then
		dolib.so "${OUT}/lib/libcam_algo_vendor_gpu.so"
	fi

	udev_dorules "${FILESDIR}/50-ipu-psys0.rules"
	udev_dorules "${FILESDIR}/99-mipicam.rules"
}
