# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="b548b650267258f203514ed37b9d02dc85cd5dc7"
CROS_WORKON_TREE="3cb528fabbae99fda9407e6a5449e678a782b3ca"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE="camera/android/header_files"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

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
	local PC_FILE_TEMPLATE="camera/android/header_files/cros-camera-android-headers.pc.template"
	local PC_FILE="${WORKDIR}/${PC_FILE_TEMPLATE##*/}"
	PC_FILE=${PC_FILE%%.template}

	insinto "${INCLUDE_DIR}"
	doins -r camera/android/header_files/include/*

	sed -e "s|@INCLUDE_DIR@|${INCLUDE_DIR}|" \
		"${PC_FILE_TEMPLATE}" > "${PC_FILE}"
	insinto "${LIB_DIR}/pkgconfig"
	doins ${PC_FILE}
}
