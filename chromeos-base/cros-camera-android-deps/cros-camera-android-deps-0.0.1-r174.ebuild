# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1dffef3b5fa35642ed3ad2b54aa7554bf0d3ed60"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "3acfc95dd3569b0195030d53f6df21df011e12cd" "0634d9b9a29d4580a1822fc26fcf1e37b87264db" "52639708fb7bf1a26ac114df488dc561a7ca9f3c")
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
