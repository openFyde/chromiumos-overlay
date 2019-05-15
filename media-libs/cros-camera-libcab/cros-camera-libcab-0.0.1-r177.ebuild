# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="ade0599d38569698afc4832f8686dc1ca76c5336"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "dabf3d92ceab817fe07dbca90b5440b676f562c6" "1b677130141daede3e21e4fce58c20fe42fed1ac" "11b38b189635a2e63dd268565504562a52278f16" "5e2f6a416f94eb6dd70589e548bbeac32fbf7c13")
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
