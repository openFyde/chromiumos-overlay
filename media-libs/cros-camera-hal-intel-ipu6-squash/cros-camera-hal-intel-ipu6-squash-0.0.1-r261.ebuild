# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="83e1cb06ba72f75f6499386930852c3a65366bc1"
CROS_WORKON_TREE="3e2080dc254951a6fed0a3efa997d4578922dff1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/intel/ipu6"

inherit cros-camera cros-workon platform

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
	# Generate the patch under platform2 by 'git format-patch HEAD^'
	epatch -p1 "${FILESDIR}/0001-intel-ipu6-Add-initial-code.patch"
}

src_install() {
	dolib.so "${OUT}/lib/libcamhal.so"
	cros-camera_dohal "${OUT}/lib/libcamhal.so" intel-ipu6.so
	dolib.so "${OUT}/lib/libcam_algo.so"
}
