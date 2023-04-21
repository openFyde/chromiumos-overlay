# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="c96fb35743ca5bbc56bf8ba4fd3ac45658dff670"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "6c6fe21162ea08ec90c2c7d7674913fa726d72af" "db263a10cec3fc724e82e1f6615e51abad77eae7" "ac22cf3b68ffe9e26404c947cdee4bf228269670" "a9a0ffa59bdd3d5f4dbcef883804d59c3b909b69" "73aa3d6be026ab3d98d6df5321892428e9d47e45" "c5a3f846afdfb5f37be5520c63a756807a6b31c4")
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
