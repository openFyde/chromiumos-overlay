# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="2107ed72bc0367fb9cad669d03cfd042ddaac08e"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "7134e391e4c04513211b250b665951820d5b0bbd" "44b5d6feda1ad2c39ad84e4fc2cc879eb6badec4" "e85dcf285699eb2caf7ae1de93a84832d626990b" "235b2660b08f58cac9ef460b4a38f95e374fdb4c" "fd02e6090c8f07ce200c4a4a20eefc55a064dc6d" "f543a07bb08e1844aa89baf2539cd77ac0ea0b61")
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
