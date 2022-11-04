# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="bdccaf1906d44ad449afdeafa0d4c1b6895342aa"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "3a939e262dbbb04bab2434b9e34a18e1f4cbda60" "efae3bd6ccd67ef806eeb091cf5ab715571fa6a3" "65642c8a1430e3822b48733b034f6c28f4ca15b9" "ea9fa272e68eab61f9328041f16682f8682ff0f2" "ddb053a6cd97035e07cab7367c7fe1b3fa3e00d2" "949c73de3faed1daba26b0dcf53a03f571b02837")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE=".gn camera/build camera/camera3_test camera/common camera/include chromeos-config common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/camera3_test"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera HAL native test."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"

RDEPEND="
	>=chromeos-base/cros-camera-libs-0.0.1-r34:=
	chromeos-base/cros-camera-android-deps
	media-libs/libexif
	media-libs/libsync
	media-libs/minigbm
	virtual/jpeg:0"

DEPEND="${RDEPEND}
	dev-cpp/gtest:=
	media-libs/libyuv
	virtual/pkgconfig"

src_install() {
	platform_src_install
	dobin "${OUT}/cros_camera_test"
	dolib.so "${OUT}/lib/libfake_date_time.so"
}
