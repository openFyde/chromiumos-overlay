# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="5afb9848de421b9fdc797450e3297f0373ec316d"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "565b7f4e28586de76c4942bdf36a8fe56572087f" "3b2a9c3dca0c9e326232c99756d04857d8a7833a" "8227f14aeaca2ab7a0b001a46b5a26b748a5bc1a" "6fb2e05a1cd872b5f2b18df2a4991d7614e78e13" "dc74dcbb8dc3aeeef2101c761a20e0f315ddd08e" "2033070eecbd4d9ad2e155923b146484239c18a7")
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
IUSE="usb_camera_monocle generated_cros_config unibuild"

RDEPEND="
	chromeos-base/cros-camera-android-deps
	chromeos-base/cros-camera-libs
	dev-libs/re2
	usb_camera_monocle? ( media-libs/librealtek-sdk )
	media-libs/libsync
	unibuild? (
		!generated_cros_config? ( chromeos-base/chromeos-config )
		generated_cros_config? ( chromeos-base/chromeos-config-bsp )
	)
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
