# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="269215d09a26f380b2835aa3ea45a69d87e64b47"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "9070f9f3e25e1440437a8814ac08615f3d9f8be4" "2624ca1aeb7f546093c8cac8244297955cb1481d" "6e314ded1aca274c35b5b5fce743f749195aa2a9" "88964300c225b7e8a3c2fe47860d091ca1f4fb65")
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

	insinto /etc/dbus-1/system.d
	doins common/dbus/CrosCameraAlgo.conf

	insinto "/usr/share/policy"
	newins "common/cros-camera-algo-${ARCH}.policy" cros-camera-algo.policy
}
