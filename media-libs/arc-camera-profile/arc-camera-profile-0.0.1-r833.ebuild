# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="f97380a4196494c65631739933f84f6f3e66e64b"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "5bf4212fe44c70fffafeadb59be046b309fb40f8" "4ace79b27b143a494a08199dfdb76832bd27193f" "262d4fb75ef54af5076c68dc5521e41bf64228dc" "92228858cd8691a5a39f68eb3f584749541c5ee4" "4a17cb7a754b78de765e63bb30c619b74cd67d1d" "bc5d73e40a959dd5e4fdb5a6431004733015ac5d")
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
	dobin "${OUT}/generate_camera_profile"
}
