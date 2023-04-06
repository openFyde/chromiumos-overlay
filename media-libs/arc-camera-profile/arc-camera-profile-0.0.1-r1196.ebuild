# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="a00bf6673b3456e56c396e7fa9afbbd590e2bc04"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "67326aa19f1aee5051aefd50a959b82d12643540" "36cbd1e51c595aae25de909ab685c451b8b84e21" "dbb36a9b1d66333ad7c4f45838c2be5cd7056682" "a55b5c7cb59d379ad7bf9c9da3a168f999f675dc" "4ba4a4fa3f1a388c740285b1e21f044a81faf2d3" "5b87e97f3ddb9634fb1d975839c28e49503e94f8")
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
