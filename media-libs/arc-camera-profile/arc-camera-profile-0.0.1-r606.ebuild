# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="6ba4d36a47a54e9c4eb11567e0f9d8c5c12c529c"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "2c045d9a78590560bd84f5de4cd7a717723a13b3" "0b28d61a072ffcd46cc19e3c281053602b0a91e6" "bc131d1a94d67238410c0dd0b2bfa4c1b55306af" "bf0f834e6b7d88dcb22d664661408d9de44e183c" "6aefce87a7cf5e4abd0f0466c5fa211f685a1193")
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
