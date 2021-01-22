# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="0de749172817084d6c0867f1c9c4ce46b64c7c3d"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "eb9df75b6c32a195902d080a694fe01bc4abca05" "b321c71344a87bd236ee4d188dc0ab88fa25d8d3" "92fa6c1373050d9593236b88ef883cf2b7d0a85a")
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
	platform_src_install
	dolib.so "${OUT}/lib/libcamera_v4l2_device.so"

	cros-camera_doheader ../../include/cros-camera/v4l2_device.h

	cros-camera_dopc libcamera_v4l2_device.pc.template
}
