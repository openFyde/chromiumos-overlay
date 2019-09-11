# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="c6e430949b7789fd1155da1ce6451cc5c30f2555"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "7134e391e4c04513211b250b665951820d5b0bbd" "ae81c4195c58ffedb325243ad03d8cc5855d7d3f" "a0510739343d9e7e5940ba1c1ad6bf74e4e34d15" "a2ee099ac3dc0b670ea7bfeaa083a1dba859ebc6" "3ec7544c4b108a15d3ea61facc0a4bbeace58eed")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcab"

inherit cros-camera cros-workon platform

DESCRIPTION="Camera algorithm bridge library for proprietary camera algorithm
isolation"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
	!media-libs/arc-camera3-libcab
	media-libs/cros-camera-libcamera_common"

DEPEND="${RDEPEND}
	media-libs/cros-camera-libcamera_ipc"

src_install() {
	dobin "${OUT}/cros_camera_algo"

	dolib.a "${OUT}/libcab.pic.a"

	cros-camera_doheader ../../include/cros-camera/camera_algorithm.h \
		../../include/cros-camera/camera_algorithm_bridge.h

	cros-camera_dopc ../libcab.pc.template

	insinto /etc/init
	doins ../init/cros-camera-algo.conf

	insinto /etc/dbus-1/system.d
	doins ../dbus/CrosCameraAlgo.conf

	insinto "/usr/share/policy"
	newins "../cros-camera-algo-${ARCH}.policy" cros-camera-algo.policy
}
