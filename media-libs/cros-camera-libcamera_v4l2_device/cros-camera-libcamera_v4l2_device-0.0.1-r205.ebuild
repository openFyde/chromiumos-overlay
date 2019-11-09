# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="757675c0110ee2de0b787f8408417a201ea7d641"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "037bc28b2ea4b37823347d9c3a9dc95c215b9794" "f7f16d5474f139cf453b503655a8e6936cb52e88" "13277321c94a2f8ea0ff6bf7d8c246ffd349380a")
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
