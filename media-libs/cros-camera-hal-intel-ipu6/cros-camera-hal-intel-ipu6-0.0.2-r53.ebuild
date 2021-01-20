# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0779e7e139d5f137b204f1c73468417083a970a5"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "4701f1c167bde1db1a809d9c5eb93f26123a37c9" "5a6658345b607258b3cafbbf3298091060659eb9" "a9a45cb5429151d83002530b9268216ffbeb8746" "aae691e78d5ccb3b7f71957aaada7e0c02c5f64f" "6e41fd99f90cf675a0dfdab474a5aa17c76f4bd2" "07bc49d879bc7ffc12a1729033a952d791f7364c" "8d228c8e702aebee142bcbf0763a15786eb5b3bb")
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
}
