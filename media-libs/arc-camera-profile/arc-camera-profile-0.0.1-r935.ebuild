# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="9b93efd97cafac6a83a04baebe8a1a4c776b16c4"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "1811069d8336280067e37e916bf8b24942da00cf" "b5603edfe1fe86b3066a17c61b4ce7fbd1b93356" "a0ea523477035e114e73b32433c7989326a0e623" "08897c4a40cbfc55436d85de2d7133d572556458" "2de57cadefcee72268944188060875f71560d058" "f13fe6260d63162b9e22bba96b94c30874378934")
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
