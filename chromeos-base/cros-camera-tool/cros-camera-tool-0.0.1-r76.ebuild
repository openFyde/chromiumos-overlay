# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT=("11be5d3f430d72c252c20fe75499c11fc74a1973" "01d9092546fa22c87ebca6d1693ed8b06d4b32e5")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "bae840cc6a5203050c6ab395cc3d0fbd74f603da" "7c4b4867ed7cedcdb8a8e0b52359477450d4fac8")
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
