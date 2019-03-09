# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="b27afc5af73fc4f0d517cda7dc3ecbc2f2a57117"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "cc63a2e0e306d52de98bc7090d77eb02f498ee94" "d6f4db45c7e14554b8bda1800fdac9acfe52c7cb" "e220eed9c62e23a855f6b5ebce2310a69a9309a5")
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
