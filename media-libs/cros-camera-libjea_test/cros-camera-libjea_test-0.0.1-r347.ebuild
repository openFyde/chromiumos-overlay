# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="c013ae3b8af8fd91db06271f88dfd9f0b14d89c1"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "801b2c0b0101245aed16c0af7d1c8cf04d9710df" "e92c12397252af71303abe9bae0819944742cd57" "093c7a01cb65cb24871c5a2ce7c2bdd0a536fccf" "8f55b22e9c73df6112ef54b4bc65462bb0bf81ed" "e378ca77690bca4c7fdce56f63b7efcf6544db6a")
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
