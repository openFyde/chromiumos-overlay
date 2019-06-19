# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="fb00b462dc21980b1e1056468e5158c0e44aa670"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "06321cd0a559d28a5a959b0448b7780da6e5c391" "fa114ae214350b09a867f8cf8f8465412d5b7d89" "6e314ded1aca274c35b5b5fce743f749195aa2a9" "bf86ccd52a8994e8c841d7b0a530173caaa5818f")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="common/libcamera_ipc.gyp"

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
	dolib.a "${OUT}/libcamera_ipc.pic.a"

	cros-camera_doheader \
		include/cros-camera/camera_mojo_channel_manager.h \
		include/cros-camera/ipc_util.h

	cros-camera_dopc common/libcamera_ipc.pc.template
}
