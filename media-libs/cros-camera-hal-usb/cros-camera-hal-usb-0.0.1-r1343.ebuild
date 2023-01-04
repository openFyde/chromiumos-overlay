# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="dfd53a9ba785e887694554c67a80dd812c6066eb"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "c40b17ba184a9e861c1b2a92ca9bf6a86e25383b" "2af139480fba08431a6d24f1f696bfd74d8f8bcb" "c901c5ae2c93caaacd85170e42bc7275c199450f" "a0af00390c3d3c63903578edd1d7c7cb504a8699" "6a36baaa49726ee92adcded5d7a9c28124985e9a")
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
