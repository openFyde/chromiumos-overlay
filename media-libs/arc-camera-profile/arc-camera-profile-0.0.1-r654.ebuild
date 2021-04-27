# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="4e9a1d8e755ae9a3e57e53bea8ea99158c7aad51"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "0f60eed03ac722447ba7b29a5770217356138404" "13276879ce388826f1969d01158ccfa3994994d4" "174d791c3b9a4ca146f7f8e4a454c6ff85be38c2" "95aa2f1c6e35782e0c2d985bf9271ec570e9a508" "c9472e5bf2ef861a0c3b602fb4ae3084a5d96ee8")
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
