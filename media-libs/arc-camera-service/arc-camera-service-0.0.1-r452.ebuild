# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="44aedde6166462e7956eb23964923e5ffd9ead3f"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "e6c659e402eee59b7789dfe5a8cff3f6b5c21ef8" "4e5bc620728bc45448817c3fbcdbccddf856b6c5" "d08b0de17491f94bdaf6aa7564df6f074fb18383" "0d8ac1008cbdcffb0b0403ed8c647c8a5084336a")
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
