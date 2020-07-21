# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="30c93f7c9a8195a7bcfe84a23e213b9de3f8958c"
CROS_WORKON_TREE="db3c09d0f81bad7c0ec27c6e3dedd87feb8d580c"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/intel/ipu6"

inherit cros-camera cros-workon platform udev

DESCRIPTION="Intel IPU6 (Image Processing Unit) Chrome OS camera HAL"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="ipu6 ipu6se"

RDEPEND="dev-libs/expat
	media-libs/cros-camera-libcbm
	media-libs/cros-camera-libcamera_client
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_exif
	media-libs/cros-camera-libcamera_metadata
	media-libs/cros-camera-libcamera_v4l2_device
	media-libs/libyuv
	media-libs/libsync"

DEPEND="${RDEPEND}
	media-libs/cros-camera-libcab
	sys-kernel/linux-headers
	media-libs/cros-camera-android-headers
	virtual/jpeg:0
	virtual/pkgconfig"

src_unpack() {
	platform_src_unpack
	cd "${P}/platform2" || die
	if [ "${PV}" != "9999" ]; then
		# Generate the patch under platform2 by 'git format-patch HEAD^'
		epatch -p1 "${FILESDIR}/0001-intel-ipu6-Add-initial-code.patch"
	fi
}

src_install() {
	dolib.so "${OUT}/lib/libcamhal.so"
	cros-camera_dohal "${OUT}/lib/libcamhal.so" intel-ipu6.so
	dolib.so "${OUT}/lib/libcam_algo.so"

	udev_dorules "${FILESDIR}/50-ipu-psys0.rules"
}
