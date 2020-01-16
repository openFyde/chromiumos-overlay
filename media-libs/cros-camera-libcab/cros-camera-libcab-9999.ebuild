# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

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
KEYWORDS="~*"

RDEPEND="
	!media-libs/arc-camera3-libcab
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_ipc"

DEPEND="${RDEPEND}"

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
