# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="f4be3fbf604d2f69b13606e703741b2d0178cebd"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "2d366491cf641c57ce6efab59652a285bba7065d" "df8b92601642272b22c923611d7733626e13f212" "3ebff40dbc00bc39f0d75d7cd931ef7d9435b592" "f86b3dad942180ce041d9034a4f5f9cceb8afe6b")
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
