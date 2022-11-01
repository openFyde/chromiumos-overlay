# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="e5a983b36bd4134608c55a05deabc8f4e6ed0888"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "3a939e262dbbb04bab2434b9e34a18e1f4cbda60" "40c94b4ea3291980518d6fee7b6a11169b16a594" "095773ad1968237a4fc049b672ba98a15150b28c" "4ede3ddc0d52286138bb98a220aa3b06b416afd9" "a414ace51a41170fc4d47926ed6da0bf35cf12da" "9a0ec44ed6c57e4b04ac8431fb5eb18840b10235" "d2206627899e0f849927c1b57c40a7095808d61e" "bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a")
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
