# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="c90aa6f17dcbdeaf4e7c5ce155f3a685afdbfd01"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "8383c2fd3af083dd87fc659f1f91fbd89c5062d4" "8d9ede4eb3f0eac16f3a813c83938cbc010b1a99" "6efa0db0e49014be7389d66af98ab7469b93fc60")
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
	dolib.so "${OUT}/lib/libcamera_common.so"

	cros-camera_doheader ../../include/cros-camera/common.h \
		../../include/cros-camera/constants.h \
		../../include/cros-camera/export.h \
		../../include/cros-camera/future.h \
		../../include/cros-camera/future_internal.h \
		../../include/cros-camera/camera_thread.h

	cros-camera_dopc ../libcamera_common.pc.template
}
