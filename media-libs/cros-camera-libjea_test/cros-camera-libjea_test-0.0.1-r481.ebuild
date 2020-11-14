# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="f4be3fbf604d2f69b13606e703741b2d0178cebd"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "bd705d8b91888cf63477309178843805641b1158" "3ebff40dbc00bc39f0d75d7cd931ef7d9435b592" "7efb7c7abf456762653f85c43a01f05aae4fb7ee" "f86b3dad942180ce041d9034a4f5f9cceb8afe6b" "7c49faa8392a94e14ae32a1d4ee7177ab7307c2a")
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
	>=chromeos-base/metrics-0.0.1-r3152
	dev-cpp/gtest:=
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_exif
	media-libs/cros-camera-libcamera_ipc
	media-libs/cros-camera-libcamera_metadata
	media-libs/cros-camera-libcbm
	media-libs/libyuv"

DEPEND="${RDEPEND}
	>=chromeos-base/metrics-0.0.1-r3152
	media-libs/libyuv
	media-libs/cros-camera-android-headers"

src_install() {
	platform_src_install
	dobin "${OUT}/libjea_test"
}
