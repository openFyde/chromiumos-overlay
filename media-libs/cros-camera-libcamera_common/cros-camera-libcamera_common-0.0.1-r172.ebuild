# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="824a54b8fee4c536600a76e7729fbb086fb625f4"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "2330cadeadba6de140c9ad8aa826812212ef9bcc" "b496323111ff12c540849b4c9dd134d877cbb38b" "6a8fe02405fcf0d44f17e743ef41280961e8b8c8")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="common/libcamera_common.gyp"
CROS_CAMERA_TESTS=(
	"future_unittest"
)

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS HAL common util."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/arc-camera3-libcamera_common
	virtual/libudev"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

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
