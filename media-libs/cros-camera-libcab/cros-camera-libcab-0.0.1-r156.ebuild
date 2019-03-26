# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="a38a15438ecb2c187bad765afa58c05853fc800e"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "45a4a9cd200b1b8ad65fc076ebfb5854a1bcf62a" "582ce1558b3cc71655bd37abf8be4acdec8b41a2" "2704fc4f555038004e6c9e52db1f60302619e8af" "13228e56ac75327ed92fe81d6a0ed4f5c11c2a6a")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="common/libcab.gyp"

inherit cros-camera cros-workon platform

DESCRIPTION="Camera algorithm bridge library for proprietary camera algorithm
isolation"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/arc-camera3-libcab
	media-libs/cros-camera-libcamera_common"

DEPEND="${RDEPEND}
	media-libs/cros-camera-libcamera_ipc"

src_install() {
	dobin "${OUT}/cros_camera_algo"

	dolib.a "${OUT}/libcab.pic.a"

	cros-camera_doheader include/cros-camera/camera_algorithm.h \
		include/cros-camera/camera_algorithm_bridge.h

	cros-camera_dopc common/libcab.pc.template

	insinto /etc/init
	doins common/init/cros-camera-algo.conf

	insinto "/usr/share/policy"
	newins "common/cros-camera-algo-${ARCH}.policy" cros-camera-algo.policy
}
