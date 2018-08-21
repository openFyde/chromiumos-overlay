# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("061b871519da53b21e86a91cec9a7866bf4fcf52" "dd0fe897461589844c9313444c6ee8d74a5fdf6f")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "52f1325cf270a13e8df427b912e44d373c99f757" "15c6d2b3c8226508b7434556acbda449e788a508" "f4f32d7978699c3b7f803f658f33778abbb7aad2")
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
