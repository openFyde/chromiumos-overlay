# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT=("d0fe7a6a33ec9c7f4466c9a274bbf8e764106185" "1e20695ea39b1f1e8b4292dee295dba2da9b925a")
CROS_WORKON_TREE=("c022e21042aa1caee1e7f60df754cf23234632ea" "6589055d0d41e7fc58d42616ba5075408d810f7d" "190c4cfe4984640ab62273e06456d51a30cfb725")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/arc-camera"
	"chromiumos/platform2"
)
CROS_WORKON_LOCALNAME=(
	"../platform/arc-camera"
	"../platform2"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/arc-camera"
	"${S}/platform2"
)
CROS_WORKON_SUBTREE=(
	"hal/usb_v1 build"
	"common-mk"
)
PLATFORM_GYP_FILE="hal/usb_v1/arc_camera_service.gyp"

inherit cros-workon platform user

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

src_unpack() {
	local s="${S}"
	platform_src_unpack
	# look in src/platform/arc-camera
	S="${s}/platform/arc-camera"
}

src_install() {
	dobin "${OUT}/arc_camera_service"

	insinto /etc/init
	doins hal/usb_v1/init/arc-camera.conf
}

pkg_preinst() {
	enewuser "arc-camera"
	enewgroup "arc-camera"
}
