# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="f8d0f6ce00239e339c164c792481e996d3948ee1"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "216b7541a029e8b42b69dcb77b4a43309868a9b1" "d08b0de17491f94bdaf6aa7564df6f074fb18383" "638bfde957a502ad58d182712c1ebdf335f9a3da")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common/v4l2_device camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/v4l2_device"

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

	cros-camera_doheader ../../include/cros-camera/v4l2_device.h

	cros-camera_dopc libcamera_v4l2_device.pc.template
}
