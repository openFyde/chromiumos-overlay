# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="17b756cad3e86a0f6560df9bb91fdbeeee8b39ba"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "3acfc95dd3569b0195030d53f6df21df011e12cd" "bf0681016b4ac1c0f992c519e348a7f4e8b97cd5" "a0066f7464336fdb7a1285270a5ac4ed80a6d15b" "52639708fb7bf1a26ac114df488dc561a7ca9f3c")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/tools camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/tools/cros_camera_tool"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera test utility."

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="chromeos-base/cros-camera-libs:="

BDEPEND="virtual/pkgconfig"

src_install() {
	platform_src_install
	dobin "${OUT}/cros-camera-tool"
}
