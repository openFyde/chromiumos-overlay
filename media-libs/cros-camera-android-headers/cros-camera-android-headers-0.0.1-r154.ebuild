# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="aa3a2a941184d9a8cbd59b2fd613cd9272f1140f"
CROS_WORKON_TREE="acccc41da5bcddd8f3f13f1bce13a9d5cecd3684"
CROS_WORKON_PROJECT="chromiumos/platform/arc-camera"
CROS_WORKON_LOCALNAME="../platform/arc-camera"

inherit cros-workon

DESCRIPTION="Android header files required for building camera HAL v3"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="!media-libs/arc-camera3-android-headers"

src_compile() {
	true
}

src_install() {
	local INCLUDE_DIR="/usr/include/android"
	local LIB_DIR="/usr/$(get_libdir)"
	local PC_FILE="android/header_files/cros-camera-android-headers.pc"

	insinto "${INCLUDE_DIR}"
	doins -r android/header_files/include/*

	sed -e "s|@INCLUDE_DIR@|${INCLUDE_DIR}|" \
		"${PC_FILE}.template" > "${PC_FILE}"
	insinto "${LIB_DIR}/pkgconfig"
	doins ${PC_FILE}
}
