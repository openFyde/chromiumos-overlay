# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT=("aa3a2a941184d9a8cbd59b2fd613cd9272f1140f" "ff6532b9bafea6c0b643a545303ef3b7e9352e1a")
CROS_WORKON_TREE=("cad58bc82a7e34a78fb8fdcde89a3d815526b756" "6589055d0d41e7fc58d42616ba5075408d810f7d" "310a710d6c1f02a93504b35b3d8371875f253b6a")
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
