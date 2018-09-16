# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("7ef0501d884da833ce0b097ed77c82568b03043a" "dea98c10047db8950a9a7de122ddd03b6e3ff83e")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "de8fa4cecc59ae774f2a38fb5c4697e410ab9a22" "9d638a1a343435b07bc0c59692b5a6d64276df2a")
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
PLATFORM_GYP_FILE="android/libcamera_metadata/libcamera_metadata.gyp"

inherit cros-camera cros-workon

DESCRIPTION="Android libcamera_metadata"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"

RDEPEND="!media-libs/arc-camera3-libcamera_metadata"

DEPEND="${RDEPEND}
	media-libs/cros-camera-android-headers"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	local INCLUDE_DIR="/usr/include/android"
	local LIB_DIR="/usr/$(get_libdir)"
	local SRC_DIR="android/libcamera_metadata"

	dolib.so "${OUT}/lib/libcamera_metadata.so"

	insinto "${INCLUDE_DIR}/system"
	doins "${SRC_DIR}/include/system"/*.h
	# Install into the system folder to avoid cros lint complaint of "include the
	# directory when naming .h files"
	doins "${SRC_DIR}/include/camera_metadata_hidden.h"

	sed -e "s|@INCLUDE_DIR@|${INCLUDE_DIR}|" -e "s|@LIB_DIR@|${LIB_DIR}|" \
		"${SRC_DIR}/libcamera_metadata.pc.template" > \
		"${SRC_DIR}/libcamera_metadata.pc"
	insinto "${LIB_DIR}/pkgconfig"
	doins "${SRC_DIR}/libcamera_metadata.pc"
}
