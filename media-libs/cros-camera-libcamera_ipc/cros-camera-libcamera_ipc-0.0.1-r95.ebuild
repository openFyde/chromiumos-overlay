# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("11aeff16fccbc8b203813acedc0f965976790512" "4ec439e9d019ba1f3448ba99e333287f0b256add")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "94142cefd7fdd6f64af78dcb1ddee28b923670c7" "f62010221e3eb0566f97bc9fe74a5d47808c8cc4" "62e34ac946e6d1a95cc072d886d6a7087bb6c820" "190c4cfe4984640ab62273e06456d51a30cfb725")
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
