# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6616ec8883ca6d764f5c519293a3eb87166d95e9"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "e5bab9aeb635f426a5f77597edb46ad386ad0f7c" "6675ee88e02a0fc7d69be0173e1d9af0812751f6" "66620b9095b5bf39fa51c8e546595edadafdadaa")
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
