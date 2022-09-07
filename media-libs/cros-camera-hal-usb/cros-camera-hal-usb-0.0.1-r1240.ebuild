# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="3b111282f1324ec462d705372b441e28f6caefb9"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "56ebaba2bbb985bdfae612ea5533ddf02fdf1548" "f01918105d4fd88f49e1287e635df4c0f97b9e9b" "97ca209b764b6cdb426dc3a755cf8b812ecadde0" "dfca03ac1f2edbf642708af0992891cc93024aa8" "8821bec7557652f636e7eed8ee7944b23b50b4b8" "589372b673eac2125688c94181c9b91cb1a50f06")
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
		# TODO(b/193747946): Remove the condition once we solve the camera
		# libraries missing when running with asan enabled issue.
		if ! use asan; then
			platform_test run "${OUT}/${test_bin}"
		fi
	done
}
