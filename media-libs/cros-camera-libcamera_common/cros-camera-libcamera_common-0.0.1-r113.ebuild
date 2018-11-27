# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("56a70ca5fdbcbac4f98e7363be6900d72585b575" "31bb9634c706a7d5c150680a8921e809fe3a2b03")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "582f98ce5a19772040687f08503eb29ffeca8677" "3ef1cf278293474828fe440e490f1e5c740f2fb6" "f686c2461d2a814ae8615206c7cd73f46fa51482")
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
