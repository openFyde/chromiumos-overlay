# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="9b0c676e258052689c96ff295035d4cb68424a12"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "263ebcdbb24ad3dc64e7ee04e08058af459c3fad" "1ab12eb0eb36de7f5eefdd18c552cdf9ebda4232" "12c17125945225da59b1bd19199cfc6006f0bdf8" "cfa34661bfaee28c42a96a4571cbd091686716bb" "080361d5d45e74e7927e56bab774531748d1a569" "17c0af603db6e69e7d5b07fe21738237ebe29f3f" "8d9f0365ffbec8f142885c1806cc2d9e59de7e0b" "945578e86a0ba4f2fd2f15f9b368a26a919b3d4d")
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
