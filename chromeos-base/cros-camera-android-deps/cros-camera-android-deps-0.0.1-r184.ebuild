# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4a0b13a6568decfa8e4523dfdf936b4073ce2e87"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "89b0f131f6910f7ae898d02db7002d0485233e95" "0634d9b9a29d4580a1822fc26fcf1e37b87264db" "bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a")
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
