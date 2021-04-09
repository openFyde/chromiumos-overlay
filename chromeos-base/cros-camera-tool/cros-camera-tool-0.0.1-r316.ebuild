# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e2c31be2c6dea118b5f77bc9ec1f4f470abdf6e2"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "95aa2f1c6e35782e0c2d985bf9271ec570e9a508" "a54d2df3e8853d5a5f1e0854b36d8d850db3611e")
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
