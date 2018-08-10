# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT=("6ee4ea8eb3e17d40337cb31f5c1f259ccc88d5f8" "eee36c5192f4eaa2959f1b532c00d6d021b32c91")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "bae840cc6a5203050c6ab395cc3d0fbd74f603da" "45463f6780972e10b5979ed201843a5dd6e93b53")
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
