# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="270ea3162fd6db4c72ea7dccf94dd33dad13a395"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "51689c7e1984b0179d7e1a2a13a21ca601441389" "aac6acf155e37c38ff9504a0aec8a269bb2f3e20" "06611b947d65e65f4f7aa5a704d90af05b40dc81" "81f7fe23bf497aafef6d4128b33582b4422a9ff5")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# TODO(crbug.com/914263): camera/hal/usb is unnecessary for this build but is
# workaround for unexpected sandbox behavior.
CROS_WORKON_SUBTREE=".gn camera/build camera/hal/usb camera/hal/usb_v1 camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/usb_v1"

inherit cros-workon platform user

DESCRIPTION="ARC camera service. The service is in charge of accessing camera
device. It uses linux domain socket (/run/camera/camera.sock) to build a
synchronous channel."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"

RDEPEND="
	!chromeos-base/arc-camera-service
	media-libs/cros-camera-libcamera_timezone"

DEPEND="${RDEPEND}
	chromeos-base/libbrillo
	virtual/pkgconfig"

src_install() {
	dobin "${OUT}/arc_camera_service"

	insinto /etc/dbus-1/system.d
	doins org.chromium.ArcCamera.conf

	insinto /etc/init
	doins init/arc-camera.conf
}

pkg_preinst() {
	enewuser "arc-camera"
	enewgroup "arc-camera"
}
