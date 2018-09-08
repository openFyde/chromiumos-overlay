# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("fbff8c674799cf83e460f9a85e7bfd4ac6ed0b12" "c5516d8b22d5f6d8249f17e38abf0c8d8557635a")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "49abb24bed5fdb6d528d44ee7fa66e1cdb0b84af" "15c6d2b3c8226508b7434556acbda449e788a508" "092c97ee52fb1dee1bb34b887be6d11b3b1dfb84")
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
	"build common include"
	"common-mk"
)
PLATFORM_GYP_FILE="common/libcbm.gyp"
CROS_CAMERA_TESTS=(
	"cbm_unittest"
)

inherit cros-camera cros-workon

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

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dolib.so "${OUT}/lib/libcbm.so"

	cros-camera_doheader include/cros-camera/camera_buffer_manager.h

	cros-camera_dopc common/libcbm.pc.template
}
