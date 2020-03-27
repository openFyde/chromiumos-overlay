# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="6ef84c8f83c06e5d5833b9213b4d076db4d472da"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "7d460d2da286d6e7ed8fd47fe005ee3040ccb930" "0492d60b3d695cd57a4507c6a2e2b02eca75e428" "49465e6ae679781cd28e7fbcc437240fde9ad73f" "612b52cf28b0531da3b29d6a9af5ac2a8c60e6bb" "093c7a01cb65cb24871c5a2ce7c2bdd0a536fccf" "dea48af07754556aac092c0830de0b1ab410077b" "c218b19793213fbc08daad20dce926cf44766c10")
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
