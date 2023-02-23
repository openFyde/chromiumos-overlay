# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="f3a8f90fef8f03f4b2b2c07e91dd68750331473c"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "9e66d15f43e66344e17d7e52447509a463655cb7" "29f9cee2a6fe34fc635513f91b18f6a73d6b5062" "8e57c159340e360878b780d73ea9e75c72476f3b" "4ba4a4fa3f1a388c740285b1e21f044a81faf2d3" "92a7718bfe5a15c594fcc6b0855e68b0981cd9a0")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/usb camera/include camera/tools common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/tools/generate_camera_profile"

inherit cros-camera cros-workon platform

DESCRIPTION="Runtime detect the number of cameras on device to generate
corresponding media_profiles.xml."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND=""

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	platform_src_install

	dobin "${OUT}/generate_camera_profile"
}
