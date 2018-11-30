# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("aa3a2a941184d9a8cbd59b2fd613cd9272f1140f" "ff6532b9bafea6c0b643a545303ef3b7e9352e1a")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "e0bc9c2ac0ad66cbe37d7755142246d9f0d622f1" "155980e1c2bd87fc6639347a774cfa3858c96903" "bae840cc6a5203050c6ab395cc3d0fbd74f603da" "310a710d6c1f02a93504b35b3d8371875f253b6a")
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
