# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="eddffb488e6b0e8ba6309122b37b341057179416"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "4be8d3ae5664634825afc2e6e4b8c24816ee9b9e" "7093536475612fadc6a0afe16b8f5f4f4251e4c2" "9ff7c0ea2761e1863475bcd96a983e5e18089f57" "66167969f21d9a7bd20fc7fd2e582ad849d7d8eb" "2b7909959649540a63997338914ec45cf9c7d07c" "aae8bf048bbe1147ff2aa47f59de29bad1b6355d" "527abd7a988a45572305a6c44b5324d0d9cf8be2" "60fa47aebd6ebfb702012849bd560717fceddcd4")
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
