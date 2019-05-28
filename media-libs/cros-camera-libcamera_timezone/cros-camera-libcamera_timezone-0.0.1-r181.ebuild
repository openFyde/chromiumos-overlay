# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="a45fb61d436c7b33173877c0836c2d71522482d4"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "45464e41994abf1413eebb9ffcc37830338a1cf4" "4ad7b2111cccd3e5e342184d5cfc3ff20201e4b2" "b6d5f3b4668764bf453c7f46c4240583d97c31fd")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="common/libcamera_timezone.gyp"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera HAL Time zone util."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="!media-libs/arc-camera3-libcamera_timezone"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	dolib.so "${OUT}/lib/libcamera_timezone.so"

	cros-camera_doheader include/cros-camera/timezone.h

	cros-camera_dopc common/libcamera_timezone.pc.template
}
