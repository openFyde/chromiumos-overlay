# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="11a92a3e1785c92cba2e0a2eb131d697d9afc7fc"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "d3cdf6e1d3413a597340657946af477bcefb531d" "14f00dcafbef98a768f7f7be17cb697ac12dc529" "f475957769dc5f27cd6e5ea08094e577adb5c5af" "3f8a9a04e17758df936e248583cfb92fc484e24c")
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
