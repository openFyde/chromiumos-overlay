# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="7867a081fe3df6946ae41107f6f34897a8fec151"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "68fdc0f7ad16e2c582ba2751fc2ba287e8139608" "6e2edfba3a5d45e06a0b643e8e0407f2c32468e1" "84441b28a7584715021e2faf292e0cf5864ea8bf" "b6b10e03115551b69ba9e2502b15d5467adcd107")
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
