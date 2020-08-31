# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1d1c1923ac2b514020d6d752ee3381bdb7589836"
CROS_WORKON_TREE="a0220bd7e7d37cb366ac32b709d63483f33f9c73"
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
		eapply "${FILESDIR}/0001-intel-ipu6-Add-initial-code.patch"
	fi
}

src_install() {
	dolib.so "${OUT}/lib/libcamhal.so"
	cros-camera_dohal "${OUT}/lib/libcamhal.so" intel-ipu6.so
	dolib.so "${OUT}/lib/libcam_algo.so"

	udev_dorules "${FILESDIR}/50-ipu-psys0.rules"
}
