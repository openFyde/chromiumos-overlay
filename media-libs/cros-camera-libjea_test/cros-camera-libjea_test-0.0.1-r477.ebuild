# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="0430ee85363346e036df6f88af08ce3765435f97"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "0c5dd9314b371b69ea4c6552b948251370b301db" "85dcd31292e99125b2eb2744c83442e00dece79f" "7efb7c7abf456762653f85c43a01f05aae4fb7ee" "abc7e8d3093049ed5a5825a5630870b13d1ad4d2" "7c49faa8392a94e14ae32a1d4ee7177ab7307c2a")
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
