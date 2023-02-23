# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f3a8f90fef8f03f4b2b2c07e91dd68750331473c"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "9e66d15f43e66344e17d7e52447509a463655cb7" "8e57c159340e360878b780d73ea9e75c72476f3b" "29f9cee2a6fe34fc635513f91b18f6a73d6b5062" "92a7718bfe5a15c594fcc6b0855e68b0981cd9a0")
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
