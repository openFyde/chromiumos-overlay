# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("a2bf92c5f97626f20da000be873944d3b5142d70" "207b9c95e801b90f6616962cb928bec371aed39f")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "d3b0291c98e3e595e4e8bfb534331d32f45c38a3" "0317ae0ee6da82324dfb7e3166f9c7ce5ac42f95" "8f3859492d0228b565f17f02fe138f81617c6415" "17f4a6efa079886fb3e23fd256264f932d59721d")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/arc-camera"
	"chromiumos/platform2"
)
CROS_WORKON_LOCALNAME=(
	"../platform/arc-camera"
	"../platform2"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/arc-camera"
	"${S}/platform2"
)
CROS_WORKON_SUBTREE=(
	"build common include mojo"
	"common-mk"
)
PLATFORM_GYP_FILE="common/libcab.gyp"

inherit cros-camera cros-workon

DESCRIPTION="Camera algorithm bridge library for proprietary camera algorithm
isolation"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/arc-camera3-libcab
	media-libs/cros-camera-libcamera_common"

DEPEND="${RDEPEND}
	chromeos-base/libmojo
	media-libs/cros-camera-libcamera_ipc"

src_unpack() {
	cros-camera_src_unpack
}

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
