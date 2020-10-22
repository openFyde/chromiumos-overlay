# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="3aa328e44839593b89e515c899945f2cf1621b54"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "b86ac1520beb83281cc81eb2172e7b4d5847472d" "85dcd31292e99125b2eb2744c83442e00dece79f" "6cadd9f53ad2c518aa18312d8ea45915a3dd112a")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcamera_common"
CROS_CAMERA_TESTS=(
	"future_test"
)

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS HAL common util."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/arc-camera3-libcamera_common
	virtual/libudev"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	platform_src_install
	dolib.so "${OUT}/lib/libcamera_common.so"

	cros-camera_doheader ../../include/cros-camera/common.h \
		../../include/cros-camera/constants.h \
		../../include/cros-camera/cros_camera_hal.h \
		../../include/cros-camera/export.h \
		../../include/cros-camera/future.h \
		../../include/cros-camera/future_internal.h \
		../../include/cros-camera/camera_thread.h

	cros-camera_dopc ../libcamera_common.pc.template
}
