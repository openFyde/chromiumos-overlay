# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="253a2b0cadfab141d4d98882476b7cac6cdde057"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "2330cadeadba6de140c9ad8aa826812212ef9bcc" "b496323111ff12c540849b4c9dd134d877cbb38b" "3f7d7bccbeae3471d2d07f6b9475461da31a8e78")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="common/libcbm.gyp"
CROS_CAMERA_TESTS=(
	"cbm_unittest"
)

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera HAL buffer manager."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/arc-camera3-libcbm
	media-libs/minigbm
	x11-libs/libdrm"

DEPEND="${RDEPEND}
	media-libs/cros-camera-android-headers
	virtual/pkgconfig"

src_install() {
	dolib.so "${OUT}/lib/libcbm.so"

	cros-camera_doheader include/cros-camera/camera_buffer_manager.h

	cros-camera_dopc common/libcbm.pc.template
}
