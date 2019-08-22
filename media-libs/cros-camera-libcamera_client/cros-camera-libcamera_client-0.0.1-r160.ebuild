# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="66ed10a4e172bdd47b4e08f1661fe21e975c2ef9"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "7134e391e4c04513211b250b665951820d5b0bbd" "54a92532d101fecd910a954e9b3229cc0173f2ed" "730940d1ad982b0928be2d517a8583b66235e15e")
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
