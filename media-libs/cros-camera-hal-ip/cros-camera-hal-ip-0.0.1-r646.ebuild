# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="07c65ddc3d0f3a2d0d1e267604dd6a707ca57d3e"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "e5bab9aeb635f426a5f77597edb46ad386ad0f7c" "7ef04f3cd2d09fe922aad4b8764995050b7b7c3f" "12c17125945225da59b1bd19199cfc6006f0bdf8" "48486f1ad6d5dd34d8b84cc7367d3844e569faf4" "bc4535a74294d86e7498615d12148925185988ee" "3c5ca428d9c43db3d5231c40ac22d4cb7c77900a" "e51266d646616e6c0bea40882fc482425e982936" "2f8a3fd5e0af952f605c8e7b8afa1ecedad683fa")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/ip camera/hal/usb camera/include camera/mojo chromeos-config common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/ip"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS IP camera HAL v3."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
RDEPEND="
	chromeos-base/chromeos-config-tools
	chromeos-base/cros-camera-android-deps
	chromeos-base/cros-camera-libs
	media-libs/libsync"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	cros-camera_dohal "${OUT}/lib/libcamera_hal.so" ip.so
}

platform_pkg_test() {
	platform_test run "${OUT}"/request_queue_test
}
