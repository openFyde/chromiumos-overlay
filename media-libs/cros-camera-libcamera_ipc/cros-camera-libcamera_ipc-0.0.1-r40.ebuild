# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("6d5f1d912fa8b9bf00f75836eab547e3e03b2688" "a62bdbc8448437a4b2df1e41e72e524b77da207b")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "743d220243a801114bf32893bd59865830667327" "7db7e0f493ad0b47165e64d5c78cf43c560326cc" "04d2f915e83148f85ce085e7ee18f2506ec85a47" "4de5b47aa71513ccaa9d92456e87e542440ae0c0")
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
