# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="053cceddbcddb5eba7159ea65f77323cd54d9b3b"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "1811069d8336280067e37e916bf8b24942da00cf" "5491d0428e0e081b35d24fc19711a257a0e94ac5" "80cb8f12c0301185d0d7b3ad286ee3bb767298a5" "a0ea523477035e114e73b32433c7989326a0e623" "e8c8ddc463c0f9f733053b2a4a0f6fda2d26c85c" "0a6d4dbdf397fb89f6c03afb0230c188ae632ead" "09f0d848aa795231ff5600313f0cd322d7ab5ba8" "a9993146a8a90e5f59f9916d3a9a3d4035ecff7e")
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
