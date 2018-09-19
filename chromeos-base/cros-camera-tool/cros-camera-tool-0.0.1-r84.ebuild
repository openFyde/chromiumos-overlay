# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT=("fdf996d2a18b50880464c13549f83537f2efcab5" "6ff57fa38a9d7ef01f2eef93680aa515f5fdba98")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "bae840cc6a5203050c6ab395cc3d0fbd74f603da" "db103a9dd2c79eed8075b58d7c1c4484354a1683")
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
	"build tools"
	"common-mk"
)
PLATFORM_GYP_FILE="tools/cros_camera_tool.gyp"

inherit cros-camera cros-workon

DESCRIPTION="Chrome OS camera test utility."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dobin "${OUT}/cros-camera-tool"
}
