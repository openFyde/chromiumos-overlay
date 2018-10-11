# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("dfaf9588d96c8d8d6b8d6d35c21b0f4584e9f94b" "525deb972a924c2ef03656ea50f8c4e71a1205dc")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "3689ecf6b9e4d59cad6c442cff58b0664eefc4c2" "f62010221e3eb0566f97bc9fe74a5d47808c8cc4" "bae840cc6a5203050c6ab395cc3d0fbd74f603da" "5d76066514dca6a32e833620a997a659f7fb2fd0")
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
	"build hal/usb include tools"
	"common-mk"
)
PLATFORM_GYP_FILE="tools/generate_camera_profile.gyp"

inherit cros-camera cros-workon

DESCRIPTION="Runtime detect the number of cameras on device to generate
corresponding media_profiles.xml."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
	media-libs/cros-camera-libcamera_timezone"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dobin "${OUT}/generate_camera_profile"
}
