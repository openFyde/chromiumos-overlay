# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("0a118b4b802470be9575762446cf0d5c41f306f4" "adac8fc6ca32bc376332d316872a85b068d4d232")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "ad6705ef10f3a1ddcc06ad5623f8d67ab0599ca9" "311011cf0c6051487ea5ae41982146a78daba303" "6dd24c3358b82474c558c65a0d6e0d3f3d9193c4")
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
	"build common include"
	"common-mk"
)
PLATFORM_GYP_FILE="common/libcamera_timezone.gyp"

inherit cros-camera cros-workon

DESCRIPTION="Chrome OS camera HAL Time zone util."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="!media-libs/arc-camera3-libcamera_timezone"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dolib.so "${OUT}/lib/libcamera_timezone.so"

	cros-camera_doheader include/cros-camera/timezone.h

	cros-camera_dopc common/libcamera_timezone.pc.template
}
