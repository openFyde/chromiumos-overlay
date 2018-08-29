# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("bc5ea0a1dad4d8c9735680dafe37875fa8fa6580" "53511680252dd74dba98852b5c75d768f1b2f216")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "49abb24bed5fdb6d528d44ee7fa66e1cdb0b84af" "15c6d2b3c8226508b7434556acbda449e788a508" "1fbe14d71bf30e2d05ed79c0bb0a34f0a9788558" "0a0fbef74ac40dc525a95f9339687c591f6a8534")
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
PLATFORM_GYP_FILE="common/libcamera_ipc.gyp"

inherit cros-camera cros-workon

DESCRIPTION="Chrome OS HAL IPC util."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="media-libs/cros-camera-libcamera_metadata"

DEPEND="${RDEPEND}
	chromeos-base/libmojo
	virtual/pkgconfig"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dolib.a "${OUT}/libcamera_ipc.pic.a"

	cros-camera_doheader \
		include/cros-camera/camera_mojo_channel_manager.h \
		include/cros-camera/ipc_util.h

	cros-camera_dopc common/libcamera_ipc.pc.template
}
