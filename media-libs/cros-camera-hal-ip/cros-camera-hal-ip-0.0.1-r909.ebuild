# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="d6ad98b44b72b762f68ac517167833fd6036f113"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "89b0f131f6910f7ae898d02db7002d0485233e95" "59d7bc271bdc0657f27e2bd1a3313194860a494d" "095773ad1968237a4fc049b672ba98a15150b28c" "93dc6d54b64182bf1d0811b27c850c2b523e6240" "69d594ef01f54f3b24556a6213c2e11634e5c631" "fefa46dc07b1045ed94377bd79f0ec4cac20f50a" "c081dfdce33cdc23b6c225e85ad84e61bb77b521" "bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a")
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
