# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1007e36b0e85b85b2140e91cb52ae9041b6df40f"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "1811069d8336280067e37e916bf8b24942da00cf" "efe904e8c621b150b9937196a1b506dfbdc10ece" "455da79bcff0fd8f44fbae5ad5e1d23e5ffd09fd")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/android common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/android"

inherit cros-workon platform

DESCRIPTION="Android dependencies needed by cros-camera service and vendor HALs"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/cros-camera-android-headers
	!media-libs/cros-camera-libcamera_client
	!media-libs/cros-camera-libcamera_metadata
"

src_configure() {
	cros_optimize_package_for_speed
	platform_src_configure
}

src_install() {
	platform_src_install

	local include_dir="/usr/include/android"

	insinto "${include_dir}"
	doins -r header_files/include/*

	insinto "${include_dir}"/system
	doins libcamera_metadata/include/system/*.h
	# Install into the system folder to avoid cros lint complaint of
	# "include the directory when naming .h files"
	doins libcamera_metadata/include/camera_metadata_hidden.h

	insinto "${include_dir}"/camera
	doins libcamera_client/include/camera/*.h

	dolib.so "${OUT}"/lib/libcros_camera_android_deps.so

	insinto /usr/"$(get_libdir)"/pkgconfig
	doins "${OUT}"/obj/camera/android/libcros_camera_android_deps.pc
}
