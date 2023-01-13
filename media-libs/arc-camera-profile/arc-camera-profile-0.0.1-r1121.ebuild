# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="a74276ad2305fbc6c0279e9874a325001d1c16d1"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "3c5ca12b75bf692fb7065af7ae3e0a181fb30ce9" "2c700a481dc1c12c228ad3bd2f25199362b28d58" "40a1c83b03a8d998cc3846a40c3ee320d6c0129f" "b87847932974eda3adf34a1dd416a24099cd9eeb" "6836462cc3ac7e9ff3ce4e355c68c389eb402bff")
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
