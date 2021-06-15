# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="a4b3f802aa9e010e2396f2fa700cc17630d6cd74"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "49e3b5c529d012af19cb326eec9cf346538d4459" "327059b614d0e0a50d150ffb598b9d1aff3d9aeb" "973c3f77d68fb4a6a30a9d7a8816b2891f4fdb46" "aff1943f46f59d9206f38765743ea9d87bf4c971" "d1fd07ac03f1ac6e670181ebd45b30e31efe5a87" "062a6da7fe49dd18c96ec59ac08784111d37b2c3")
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
