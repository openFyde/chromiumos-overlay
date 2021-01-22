# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0de749172817084d6c0867f1c9c4ce46b64c7c3d"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "bff1840b18538ec75c8d413c13735e32809ab9b3" "b321c71344a87bd236ee4d188dc0ab88fa25d8d3" "fd9f01028dd255135030e6224212288f0e5b0dcb" "92fa6c1373050d9593236b88ef883cf2b7d0a85a")
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
KEYWORDS="*"
IUSE="camera_feature_portrait_mode ipu6se"

RDEPEND="
	!media-libs/arc-camera3-libcab
	camera_feature_portrait_mode? ( media-libs/cros-camera-libcam_gpu_algo )
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_ipc"

DEPEND="${RDEPEND}"

src_install() {
	platform_src_install
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

	# The sandboxed GPU service is used by Portrait Mode feature and IPU6SE
	# camera HAL.
	if use camera_feature_portrait_mode || use ipu6se ; then
		insinto /etc/init
		doins ../init/cros-camera-gpu-algo.conf

		insinto "/usr/share/policy"
		newins "../cros-camera-gpu-algo-${ARCH}.policy" cros-camera-gpu-algo.policy
	fi
}
