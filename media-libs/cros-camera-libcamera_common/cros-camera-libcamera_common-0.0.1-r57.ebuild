# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("778039ff8512a5dd53d8fa5b48ef5d3fa2ff6ce2" "f2e28a473ffbdd9f227d623165e74370d8b04bf1")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "c1e06d9f00c106dff199c84c68f58508a9332bac" "15c6d2b3c8226508b7434556acbda449e788a508" "20ef8042a2b93c9cea9ec7eb8202ad6da6b3cd6c")
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
PLATFORM_GYP_FILE="common/libcamera_common.gyp"
CROS_CAMERA_TESTS=(
	"future_unittest"
)

inherit cros-camera cros-workon

DESCRIPTION="Chrome OS HAL common util."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/arc-camera3-libcamera_common
	virtual/libudev"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dolib.so "${OUT}/lib/libcamera_common.so"

	cros-camera_doheader include/cros-camera/common.h \
		include/cros-camera/constants.h \
		include/cros-camera/export.h \
		include/cros-camera/future.h \
		include/cros-camera/future_internal.h \
		include/cros-camera/camera_thread.h

	cros-camera_dopc common/libcamera_common.pc.template
}
