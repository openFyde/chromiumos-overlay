# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="249b91d712897cc90fe57dd60d41154c68c1a094"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "a9db923ed9d7e66024405ab4fdb8bbe178930040" "ed6e051621de7c28c8c29a7f3a08ba6f730feeb4" "daa342e364c249bb38108acc8cceb8bec692b414" "f98e6052b266920b9ea2c56b22b4f1235c57ce85" "542b6a1b940801e08d9d1aa3ff2657d06dc80bfa" "3a8b816b9fdaca04ec76e8a8d97b206e139a9dfc" "2c293b25dd09e3deae29a0dd7d637fbc1cc44597")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/usb camera/include camera/mojo chromeos-config common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/usb"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS USB camera HAL v3."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/cros-camera-android-deps
	chromeos-base/cros-camera-libs
	dev-libs/re2
	media-libs/libsync
	chromeos-base/chromeos-config-tools"

DEPEND="${RDEPEND}
	media-libs/libyuv
	virtual/pkgconfig"

src_install() {
	platform_src_install
	cros-camera_dohal "${OUT}/lib/libcamera_hal.so" usb.so
}

platform_pkg_test() {
	local tests=(
		image_processor_test
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test run "${OUT}/${test_bin}"
	done
}
