# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="666db4fd2dedc2bf2e70cb0f9bb93e26715489d6"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "3a939e262dbbb04bab2434b9e34a18e1f4cbda60" "d9adc39b49c2c36a36301721d204632fd80d2e4c" "3f6fe4eaa21bc19d6134b3c6938761aff759005c" "11cf8ee481e686c3c26349f102ea0114d8a48618" "949c73de3faed1daba26b0dcf53a03f571b02837")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/hal/usb common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/usb/tests"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS USB camera tests."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/cros-camera-v4l2_test
	chromeos-base/cros-camera-libs
	chromeos-base/libbrillo:=
	dev-cpp/gtest:=
	dev-libs/re2:=
	media-libs/libyuv
	virtual/jpeg:0
	virtual/libusb:1
"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	platform_src_install
	dobin "${OUT}/camera_characteristics_test"
	dobin "${OUT}/camera_dfu_test"
	dobin "${OUT}/media_v4l2_is_capture_device"
	dobin "${OUT}/media_v4l2_test"
}
