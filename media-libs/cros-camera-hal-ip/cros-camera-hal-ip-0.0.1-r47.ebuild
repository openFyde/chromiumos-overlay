# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="0e3b516fa60525cacebc35ab4b37b2230fdf1498"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "7c804166bb0ddf74736a4d5a8005c04605eb8fef" "cc73b4627831fee9a8d0f4514b29bed30ab1d78f" "1f099d0f564e59753d937d9699be9f9dfe6c9b07" "2ba22b88ed6c3fdb6b720b3a0c1bc4c0a17f1afa" "5d53ff58483685bdf4424a3c8e8496656e9aa83e")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/ip camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/ip"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS IP camera HAL v3."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
RDEPEND="
	chromeos-base/libbrillo
	media-libs/cros-camera-libcbm
	media-libs/libsync"

DEPEND="${RDEPEND}
	media-libs/cros-camera-android-headers
	media-libs/cros-camera-libcamera_metadata
	virtual/pkgconfig"

src_install() {
	cros-camera_dohal "${OUT}/lib/libcamera_hal.so" ip.so
}

platform_pkg_test() {
	platform_test run "${OUT}"/request_queue_test
}
