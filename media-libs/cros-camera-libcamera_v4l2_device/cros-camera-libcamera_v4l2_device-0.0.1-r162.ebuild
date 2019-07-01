# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="069f2a92133ad5b96ec25ee8c150344666b7ebad"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "7134e391e4c04513211b250b665951820d5b0bbd" "aef2e006dc0339cf5bea7b10fc5e64cc6e4d7bf8" "2624ca1aeb7f546093c8cac8244297955cb1481d" "3203fc5c38912e1d0625e33126a801b6ae1a0c59")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common/v4l2_device camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="common/v4l2_device/libcamera_v4l2_device.gyp"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera HAL v3 V4L2 device utility."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND=""

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	dolib.so "${OUT}/lib/libcamera_v4l2_device.so"

	cros-camera_doheader include/cros-camera/v4l2_device.h

	cros-camera_dopc common/v4l2_device/libcamera_v4l2_device.pc.template
}
