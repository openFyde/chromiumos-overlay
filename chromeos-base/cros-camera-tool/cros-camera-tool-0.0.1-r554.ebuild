# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="7e6a8406b63daa4577b827c85c139242210a5c5c"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "b87847932974eda3adf34a1dd416a24099cd9eeb" "86f67aee61b7bbac965e96820455a837bb4401d5" "6836462cc3ac7e9ff3ce4e355c68c389eb402bff")
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
}
