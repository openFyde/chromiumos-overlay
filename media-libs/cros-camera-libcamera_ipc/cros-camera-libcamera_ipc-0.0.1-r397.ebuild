# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="d54bbeddd2480d663bc2fc0a9b5863f6ac66f9c5"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "84c64ca566ce4c32a77e451f67d7cb35f6275253" "d6fa10cef5a85a2615e1273240c221a553b43cc3" "84441b28a7584715021e2faf292e0cf5864ea8bf" "fe8d35af30ff1c2484e01cd6235a5d45c627d10d")
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
