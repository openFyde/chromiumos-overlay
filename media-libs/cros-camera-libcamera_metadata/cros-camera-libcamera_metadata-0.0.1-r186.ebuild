# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="26ec26c4ac3ba35bf59fa5acbbd26c59a3381adc"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "54a92532d101fecd910a954e9b3229cc0173f2ed" "65558ff6a3b26d0ace511c80691b2d4c133fa71b")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/android common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/android/libcamera_metadata"

inherit cros-camera cros-workon platform

DESCRIPTION="Android libcamera_metadata"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"

RDEPEND="!media-libs/arc-camera3-libcamera_metadata"

DEPEND="${RDEPEND}
	media-libs/cros-camera-android-headers"

src_install() {
	local INCLUDE_DIR="/usr/include/android"
	local LIB_DIR="/usr/$(get_libdir)"
	local PC_FILE_TEMPLATE="libcamera_metadata.pc.template"
	local PC_FILE="${WORKDIR}/${PC_FILE_TEMPLATE##*/}"
	PC_FILE="${PC_FILE%%.template}"

	dolib.so "${OUT}/lib/libcamera_metadata.so"

	insinto "${INCLUDE_DIR}/system"
	doins "include/system"/*.h
	# Install into the system folder to avoid cros lint complaint of "include the
	# directory when naming .h files"
	doins "include/camera_metadata_hidden.h"

	sed -e "s|@INCLUDE_DIR@|${INCLUDE_DIR}|" -e "s|@LIB_DIR@|${LIB_DIR}|" \
		"${PC_FILE_TEMPLATE}" > "${PC_FILE}"
	insinto "${LIB_DIR}/pkgconfig"
	doins "${PC_FILE}"
}
