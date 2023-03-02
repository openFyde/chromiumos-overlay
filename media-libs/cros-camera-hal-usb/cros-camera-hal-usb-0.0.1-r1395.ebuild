# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="f74755aca44d1b8f06aa66fc811365b3cd02b82a"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "c903b4b1306ec4d133d339b3d17d39f362513708" "f475957769dc5f27cd6e5ea08094e577adb5c5af" "14f00dcafbef98a768f7f7be17cb697ac12dc529" "2ae3f5c18c4a966b50d7defcd4e5ecfc5d40d1d9" "0f4044624c1fabe638a8289e62ec74756aa62176")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/usb camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/usb"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS USB camera HAL v3."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="asan"

RDEPEND="
	chromeos-base/cros-camera-android-deps
	chromeos-base/cros-camera-libs
	dev-libs/re2
	media-libs/libsync"

DEPEND="${RDEPEND}
	media-libs/libyuv
	virtual/pkgconfig"

platform_pkg_test() {
	platform test_all
}
