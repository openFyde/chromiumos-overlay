# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="378450bea9f1374e98d1e597b1aa65fff5384837"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "bdce8a305b6af438503ba12680e7d8526bcc2dfc" "56b0df08066ed0030951c2b72a54a18733531138" "12c17125945225da59b1bd19199cfc6006f0bdf8" "2e03e8b30a035ac3a6b3b814ddc9f20f3a5d20bd" "05d06105393bce50730b6d7e4caaa8bc431e5723" "17c0af603db6e69e7d5b07fe21738237ebe29f3f" "e9bfdb6a0dcfc5d735382ea3094e7d5966d59414" "4a5014026787ab30d197b30eb40d6b4359a0ee09")
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
