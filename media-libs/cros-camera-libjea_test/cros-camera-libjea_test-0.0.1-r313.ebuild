# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="863fee6a770164f8a6c3c033b4de0cdecfbb8cd4"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "018d4b823f729d0b32dab4d450df7d4125845bec" "94cca01db02ec757d76d672c3fc0d4eea9a91be8" "5e3ca9673adc2f2840871ff69c318e2b191592fd" "861f66e9f884ebb293fb541a5501f183861a2dda" "7e090ba54425d36a9899ce32e6195fa8e1b93335")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/mojo common-mk metrics"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/jpeg/libjea_test"

inherit cros-camera cros-workon platform

DESCRIPTION="End to end test for JPEG encode accelerator"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/metrics
	dev-cpp/gtest:=
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_exif
	media-libs/cros-camera-libcamera_ipc
	media-libs/cros-camera-libcamera_metadata
	media-libs/cros-camera-libcbm
	media-libs/libyuv"

DEPEND="${RDEPEND}
	chromeos-base/metrics
	media-libs/libyuv
	media-libs/cros-camera-android-headers"

src_install() {
	dobin "${OUT}/libjea_test"
}
