# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcbm"
CROS_CAMERA_TESTS=(
	"cbm_test"
)

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera HAL buffer manager."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"

RDEPEND="
	!media-libs/arc-camera3-libcbm
	media-libs/minigbm
	x11-libs/libdrm"

DEPEND="${RDEPEND}
	media-libs/cros-camera-android-headers
	virtual/pkgconfig"

src_install() {
	platform_src_install
	dolib.so "${OUT}/lib/libcbm.so"

	cros-camera_doheader ../../include/cros-camera/camera_buffer_manager.h

	cros-camera_dopc ../libcbm.pc.template
}
