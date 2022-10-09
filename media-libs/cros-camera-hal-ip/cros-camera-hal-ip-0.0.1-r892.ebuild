# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="c3021c98777b335e3b655156b15bb037aba7df02"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "4fc7c463ce102d1dff62e86baffad4a67ea2c940" "535ed81ea9213eb467e18bdb6358287248f4b75e" "095773ad1968237a4fc049b672ba98a15150b28c" "6e0df3e9b16fadbd0dbe467416fa812fa4733002" "3035153259a6317eb40f4676340d6ddae5139b23" "c4267a2954a2bd2b33146b612735c5aadf83725f" "d12ed295f53b887d40f4f039cd0a09bb07530877" "4b7854d72e018cacbb3455cf56f41cee31c70fc1")
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
