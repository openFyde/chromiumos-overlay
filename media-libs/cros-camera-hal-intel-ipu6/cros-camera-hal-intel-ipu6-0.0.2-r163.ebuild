# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("4c81debf8db1e288401b6d21394154537c7fd3eb" "276d232ccf09990d330301df9a0a0bb9ef434991")
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c0c03d001677e1c1906a8cd05b4e1aa1e16bab49" "c3a482fb8f1b46d724ed179e51af553984be33cf")
CROS_WORKON_PROJECT=("chromiumos/platform2" "chromiumos/platform/camera")
CROS_WORKON_LOCALNAME=("../platform2" "../platform/camera")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/camera_hal")
CROS_WORKON_SUBTREE=(".gn common-mk" "hal/intel/ipu6")
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera_hal/hal/intel/ipu6"

inherit cros-camera cros-workon platform udev

DESCRIPTION="Intel IPU6 (Image Processing Unit) Chrome OS camera HAL"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="ipu6se ipu6ep"

RDEPEND="
	chromeos-base/chromeos-config-tools
	chromeos-base/cros-camera-libs
	chromeos-base/cros-camera-android-deps
	dev-libs/expat
	!ipu6se? ( !ipu6ep? ( media-libs/intel-ipu6-camera-bins ) )
	ipu6se? (
		media-libs/intel-ipu6se-camera-bins
		x11-libs/libva-intel-media-driver
	)
	ipu6ep? ( media-libs/intel-ipu6ep-camera-bins )
	!media-libs/cros-camera-hal-intel-ipu6-squash
	media-libs/libsync
	media-libs/libyuv
"

DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	virtual/jpeg:0
	virtual/pkgconfig"

src_install() {
	platform_src_install

	cros-camera_dohal "${OUT}/lib/libcamhal.so" intel-ipu6.so
	dolib.so "${OUT}/lib/libcam_algo.so"

	if use ipu6se; then
		dolib.so "${OUT}/lib/libcam_algo_vendor_gpu.so"
	fi

	udev_dorules "${FILESDIR}/50-ipu-psys0.rules"
}
