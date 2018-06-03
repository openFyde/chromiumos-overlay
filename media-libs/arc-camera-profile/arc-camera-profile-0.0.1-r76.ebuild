# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("fbe93a6286482eedaa04cafe20ebdde6a2897a2d" "873d7e41ddbd7a8f807477096696a4d20ec3626c")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "5f0e410c9fe4515cc1991a89b71749290171cd5c" "311011cf0c6051487ea5ae41982146a78daba303" "1c60697df0f10da379411bb7cbd79002f9714883" "6dd24c3358b82474c558c65a0d6e0d3f3d9193c4")
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
