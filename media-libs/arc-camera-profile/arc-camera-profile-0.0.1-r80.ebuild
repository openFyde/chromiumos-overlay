# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("a07b8addd62474da79a8950525c4e0cfaf3d41a9" "eec6d0a6c3962e71e3b1a7db2dfaa422ec88a15e")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "d815bb54767e70ab5d5b51e4a5501d8458a95316" "0317ae0ee6da82324dfb7e3166f9c7ce5ac42f95" "1c60697df0f10da379411bb7cbd79002f9714883" "1d995a5f11b89f06713e6b213ea3f8741ace4008")
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
