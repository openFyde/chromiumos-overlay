# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("cdebb2f32b1696841aa4ba6fc8eccf5dac8058a7" "044b7be3c864ed4a528ebffee8b2a4e5f1f11bd1")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "cd65d92b67c7bc5ab3454b79bb46f8be4971c5de" "9c2d57f35528e62d4d73f405ad0800ea16aba9f0" "bae840cc6a5203050c6ab395cc3d0fbd74f603da" "190c4cfe4984640ab62273e06456d51a30cfb725")
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
