# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a2c5fa585261eae4ef6053f24afd164b927cf080"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "bc54278f809cf701d0e479575fef5a3081d4a611" "a73317fa16214d3b4f8c03f66e0f66b5ed4f96cf" "a1b29c5affaf32e0ccf704ea2376739de5c36547" "ffccaa8b7bb1b063ae1051517543023ce055ef35" "9d86e7ec6a43a7ef09d1c859379be1a06a1b3429" "52a8a8b6d3bbca5e90d4761aa308a5541d52b1bb" "91bab993773ad1f95dd276029c7f11a0043d7e94")
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
KEYWORDS="*"
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
