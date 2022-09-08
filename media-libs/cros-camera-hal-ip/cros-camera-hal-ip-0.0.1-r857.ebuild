# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="34e152a471e256eeeaf720fd17659db1694a1ef4"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "56ebaba2bbb985bdfae612ea5533ddf02fdf1548" "fb45d2d3b2b409af9973ba8d38dba87faae5eacc" "9ff7c0ea2761e1863475bcd96a983e5e18089f57" "97ca209b764b6cdb426dc3a755cf8b812ecadde0" "2848a3b59c791c34bffdea209cbed1b9c84b7f8a" "8821bec7557652f636e7eed8ee7944b23b50b4b8" "be685e50cd6402b6c71b394cbc9798b07b526ef1" "e96c7b05f7b481bedb62e65f6e9a177306f1b5b2")
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
