# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="47c7f847879bc350067d4eda4038d1151cc0abc2"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "54a92532d101fecd910a954e9b3229cc0173f2ed" "e27f1b4637c4d92b0c7b14963d2910ad6b0b631e")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/android common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/android/libcamera_client"

inherit cros-camera cros-workon platform

DESCRIPTION="Android libcamera_client"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/arc-camera3-libcamera_client
	media-libs/cros-camera-libcamera_metadata"

DEPEND="${RDEPEND}
	media-libs/cros-camera-android-headers"

src_install() {
	local INCLUDE_DIR="/usr/include/android"
	local LIB_DIR="/usr/$(get_libdir)"
	local PC_FILE_TEMPLATE=libcamera_client.pc.template
	local PC_FILE="${WORKDIR}/${PC_FILE_TEMPLATE##*/}"
	PC_FILE="${PC_FILE%%.template}"

	dolib.so "${OUT}/lib/libcamera_client.so"

	insinto "${INCLUDE_DIR}/camera"
	doins include/camera/*.h

	sed -e "s|@INCLUDE_DIR@|${INCLUDE_DIR}|" -e "s|@LIB_DIR@|${LIB_DIR}|" \
		"${PC_FILE_TEMPLATE}" > "${PC_FILE}"
	insinto "${LIB_DIR}/pkgconfig"
	doins "${PC_FILE}"
}
