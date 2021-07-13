# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="7d1e53ece9981821cc0d1881682b833fa8f335b6"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "49e3b5c529d012af19cb326eec9cf346538d4459" "d1fd07ac03f1ac6e670181ebd45b30e31efe5a87" "404240d78ae6865dc503e0ecef12b98f2940363c")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/tools common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/tools/cros_camera_tool"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera test utility."

LICENSE="BSD-Google"
KEYWORDS="*"

BDEPEND="virtual/pkgconfig"

src_install() {
	platform_src_install
	dobin "${OUT}/cros-camera-tool"
}
