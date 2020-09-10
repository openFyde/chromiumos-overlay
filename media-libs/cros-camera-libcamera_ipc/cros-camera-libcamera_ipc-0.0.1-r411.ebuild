# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="353624ea2b9bd4c5a2d2c952cb8fc9b5057fd0f9"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "c43e4b9742eb50649c6febb66c2264f466187f7b" "4cc600d625ecfdac13d984d9190d63a8970b0a4b" "ab72b93074396d3428b557e2e00d64f487fab1e1" "b6b10e03115551b69ba9e2502b15d5467adcd107")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcamera_ipc"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS HAL IPC util."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="media-libs/cros-camera-libcamera_metadata"

DEPEND="${RDEPEND}
	media-libs/cros-camera-libcamera_common
	virtual/pkgconfig"

src_install() {
	dolib.so "${OUT}/lib/libcamera_ipc.so"
	dolib.a "${OUT}/libcamera_ipc_mojom.a"

	cros-camera_doheader \
		../../include/cros-camera/camera_mojo_channel_manager.h \
		../../include/cros-camera/ipc_util.h

	cros-camera_dopc ../libcamera_ipc.pc.template
}
