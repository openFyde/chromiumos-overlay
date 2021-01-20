# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="7133de528accd14c62bc16ce6d3c2c214db2ce49"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "c2ba80a1df21bde86eb2c715b8ab16d78878af66" "0b0bd701798d12b090a5bbbcec163ecdb45e2567" "b321c71344a87bd236ee4d188dc0ab88fa25d8d3" "07bc49d879bc7ffc12a1729033a952d791f7364c")
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
