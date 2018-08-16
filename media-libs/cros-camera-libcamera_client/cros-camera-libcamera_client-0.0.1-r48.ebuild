# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("5584f0c8f2f8fc61278e2e31af4e7aac6b9cf53b" "01a03914f9f667d18231aca0156d26eefc67d09c")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "de8fa4cecc59ae774f2a38fb5c4697e410ab9a22" "85aa802638017b4163ecde680ea5cf4b0123b0d5")
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
	"build android"
	"common-mk"
)
PLATFORM_GYP_FILE="android/libcamera_client/libcamera_client.gyp"

inherit cros-camera cros-workon

DESCRIPTION="Android libcamera_client"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/arc-camera3-libcamera_client
	media-libs/cros-camera-libcamera_metadata"

DEPEND="${RDEPEND}
	media-libs/cros-camera-android-headers"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	local INCLUDE_DIR="/usr/include/android"
	local LIB_DIR="/usr/$(get_libdir)"
	local SRC_DIR="android/libcamera_client"

	dolib.so "${OUT}/lib/libcamera_client.so"

	insinto "${INCLUDE_DIR}/camera"
	doins "${SRC_DIR}/include/camera"/*.h

	sed -e "s|@INCLUDE_DIR@|${INCLUDE_DIR}|" -e "s|@LIB_DIR@|${LIB_DIR}|" \
		"${SRC_DIR}/libcamera_client.pc.template" > \
		"${SRC_DIR}/libcamera_client.pc"
	insinto "${LIB_DIR}/pkgconfig"
	doins "${SRC_DIR}/libcamera_client.pc"
}
