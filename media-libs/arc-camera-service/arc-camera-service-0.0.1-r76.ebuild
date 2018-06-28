# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="bae54fccba5e2efd1f0b0deeccb6e8a16006ea03"
CROS_WORKON_TREE="42abc97c8048c5c21d00d592b0788f961d88a8cd"
CROS_WORKON_PROJECT="chromiumos/platform/arc-camera"
CROS_WORKON_LOCALNAME="../platform/arc-camera"

inherit cros-debug cros-workon libchrome toolchain-funcs user

DESCRIPTION="ARC camera service. The service is in charge of accessing camera
device. It uses linux domain socket (/run/camera/camera.sock) to build a
synchronous channel."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"

RDEPEND="!chromeos-base/arc-camera-service"

DEPEND="${RDEPEND}
	chromeos-base/libbrillo
	chromeos-base/libmojo
	virtual/pkgconfig"

src_configure() {
	asan-setup-env
	cros-workon_src_configure
}

src_compile() {
	cw_emake -C hal/usb_v1 arc_camera_service
}

src_install() {
	dobin arc_camera_service

	insinto /etc/init
	doins hal/usb_v1/init/arc-camera.conf
}

pkg_preinst() {
	enewuser "arc-camera"
	enewgroup "arc-camera"
}
