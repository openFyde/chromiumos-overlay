# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("44c34946304cef80bc0335e3bd941b6b77dad83e" "c3b9cef94b42c41acf8b1e5835440850559c4470")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "469e9d0e025291b19f7d53e76b4544fc494e5326" "155980e1c2bd87fc6639347a774cfa3858c96903" "710af790d9045be0e597b16d6ec2d72196fcc4ef")
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
