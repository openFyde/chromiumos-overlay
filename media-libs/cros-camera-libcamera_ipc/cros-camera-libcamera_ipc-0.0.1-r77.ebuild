# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("7c21a79a3b2c631d1804d81b970b98c3960dccc6" "04211c61ef8d1f9d680ee9db5b30ad0855f4b99e")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "5d9312be37030d88b1b912ec15b45a0127a88d53" "f62010221e3eb0566f97bc9fe74a5d47808c8cc4" "62e34ac946e6d1a95cc072d886d6a7087bb6c820" "30d49e96f78c127c17008bafed2c41d759f8abe8")
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
	media-libs/cros-camera-libcamera_common
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
