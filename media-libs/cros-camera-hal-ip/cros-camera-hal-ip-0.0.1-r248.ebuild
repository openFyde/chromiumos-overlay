# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="5735d80a4820cc87849eaaa2f3b7d24d426b707e"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "e8361dab54d0d6fb2cd71f388b8d47e0b58cf5b1" "3a22c6c7b340de72caffe397ba0a31c67282eeec" "31a8aa1968886f82a12058e0816e2b31c818b575" "d08b0de17491f94bdaf6aa7564df6f074fb18383" "84441b28a7584715021e2faf292e0cf5864ea8bf" "638bfde957a502ad58d182712c1ebdf335f9a3da" "4ddcdbcafd28c3d19d48b522c721365b9e702657")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/ip camera/hal/usb camera/include camera/mojo common-mk metrics"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/ip"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS IP camera HAL v3."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
RDEPEND="
	media-libs/cros-camera-libcbm
	media-libs/cros-camera-libjda
	media-libs/libsync"

DEPEND="${RDEPEND}
	media-libs/cros-camera-android-headers
	media-libs/cros-camera-libcamera_client
	media-libs/cros-camera-libcamera_metadata
	virtual/pkgconfig"

src_install() {
	cros-camera_dohal "${OUT}/lib/libcamera_hal.so" ip.so
}

platform_pkg_test() {
	platform_test run "${OUT}"/request_queue_test
}
