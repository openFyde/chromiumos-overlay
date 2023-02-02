# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("8b65f3619734bdfefbd32a6a4c85569190c1b82e" "de155d51460902906f589ed3b1f7ccd5a2c0d158")
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "5a857fb996a67f6c9781b916ba2d6076e9dcd0a6" "0c709316cf72b63680ca82e381c8a69365655c7e")
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
IUSE="ipu6se ipu6ep ipu6epmtl ipu6epadln"

RDEPEND="
	chromeos-base/chromeos-config-tools
	chromeos-base/cros-camera-libs
	chromeos-base/cros-camera-android-deps
	dev-libs/expat
	!ipu6se? ( !ipu6ep? ( !ipu6epmtl? ( !ipu6epadln? ( media-libs/intel-ipu6-camera-bins ) ) ) )
	ipu6se? (
		media-libs/intel-ipu6se-camera-bins
		x11-libs/libva-intel-media-driver
	)
	ipu6ep? ( media-libs/intel-ipu6ep-camera-bins )
	ipu6epadln? ( media-libs/intel-ipu6epadln-camera-bins )
	ipu6epmtl? ( media-libs/intel-ipu6epmtl-camera-bins )
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
	udev_dorules "${FILESDIR}/50-ipu-psys0.rules"
}
