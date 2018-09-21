# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT=("c10c2f508b4ed10e1f23d0577673a6396a904eb2" "12495d83b22c0a08af3f779e428e6d21eb40fa37")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "bae840cc6a5203050c6ab395cc3d0fbd74f603da" "6e7a51056a0752e4fe787085dbdfbedf6510aba8")
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
