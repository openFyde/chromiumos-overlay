# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c3c2efc1f073e04e8b9df6af2860ded0ff9a1141"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "9cb182dc53bd5bf117ef1f64b42c4535eee53ebf" "e561a53ad8f49dabb34311f6c54702134a36cdac" "3ebff40dbc00bc39f0d75d7cd931ef7d9435b592" "a661abd7c4e459764c10f7e466ee615f8c8f0cee" "f362827ede8713fe521f7b0af5dfdbed5627c34f" "f86b3dad942180ce041d9034a4f5f9cceb8afe6b" "41e588aa09391b289425ae58c40be138298c6cb0")
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
IUSE="ipu6se"

RDEPEND="
	chromeos-base/chromeos-config-tools
	chromeos-base/metrics
	dev-libs/expat
	!ipu6se? ( media-libs/intel-ipu6-libs-bin )
	ipu6se? (
		media-libs/intel-ipu6se-libs-bin
		x11-libs/libva-intel-media-driver
	)
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
