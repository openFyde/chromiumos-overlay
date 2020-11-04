# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="be1d5246361c01291e77b3ecb4fa74a212715ce9"
CROS_WORKON_TREE="4e5794bfb0a53138e52995db333f201906d18b87"
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

src_unpack() {
	platform_src_unpack
	cd "${P}/platform2" || die
	# Generate the patches under platform2 by 'git format-patch <parent_commit>'
	eapply "${FILESDIR}/0001-intel-ipu6-Add-initial-code-1st-part.patch"
	eapply "${FILESDIR}/0002-intel-ipu6-Add-initial-code-2nd-part.patch"
}

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
