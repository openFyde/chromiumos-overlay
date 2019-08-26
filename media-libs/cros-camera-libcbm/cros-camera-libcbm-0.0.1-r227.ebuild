# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="2617f00881f2c53b7ebe6c103f4165845e3b67ef"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "7134e391e4c04513211b250b665951820d5b0bbd" "0301f3c08a3238dfbc6f27f817542845d90ee614" "d20cd8a54d1cafc94ac4b7511b7c6c6e92005274" "b050a2ab2836dd6da5e48eab3fd4ac328d4325bc")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcbm"
CROS_CAMERA_TESTS=(
	"cbm_unittest"
)

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera HAL buffer manager."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/arc-camera3-libcbm
	media-libs/minigbm
	x11-libs/libdrm"

DEPEND="${RDEPEND}
	media-libs/cros-camera-android-headers
	virtual/pkgconfig"

src_install() {
	dolib.so "${OUT}/lib/libcbm.so"

	cros-camera_doheader ../../include/cros-camera/camera_buffer_manager.h

	cros-camera_dopc ../libcbm.pc.template
}
