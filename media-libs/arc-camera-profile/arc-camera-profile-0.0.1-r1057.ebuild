# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="666db4fd2dedc2bf2e70cb0f9bb93e26715489d6"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "3a939e262dbbb04bab2434b9e34a18e1f4cbda60" "d9adc39b49c2c36a36301721d204632fd80d2e4c" "11cf8ee481e686c3c26349f102ea0114d8a48618" "3f6fe4eaa21bc19d6134b3c6938761aff759005c" "bf0681016b4ac1c0f992c519e348a7f4e8b97cd5" "949c73de3faed1daba26b0dcf53a03f571b02837")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/usb camera/include camera/tools common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/tools/generate_camera_profile"

inherit cros-camera cros-workon platform

DESCRIPTION="Runtime detect the number of cameras on device to generate
corresponding media_profiles.xml."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND=""

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	dobin "${OUT}/generate_camera_profile"
}
