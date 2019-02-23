# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="724e8fed97eb25bc7f3e2d5aeceb79a5e3d1c253"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "a58c305c281cd9c4e21297b843aacf74792daeec" "df544d9e971b33202110fb8d238784a2f9f9e62d" "2704fc4f555038004e6c9e52db1f60302619e8af" "564023743cbb0d3d970ae3aeaeb717e3c5e87e0a")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="common/jpeg/libjda_test.gyp"

inherit cros-camera cros-workon platform

DESCRIPTION="End to end test for JPEG decode accelerator"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="dev-cpp/gtest"

DEPEND="${RDEPEND}
	media-libs/cros-camera-libjda"

src_install() {
	dobin "${OUT}/libjda_test"
}
