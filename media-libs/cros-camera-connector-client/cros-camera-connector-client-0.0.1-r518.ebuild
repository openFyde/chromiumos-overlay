# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f76957fa469f8af582649807981fb592f0ba1d10"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "56ebaba2bbb985bdfae612ea5533ddf02fdf1548" "318ca9f48604274cd31481e13eb9321be3d94d8f" "95cb3d0b604e91088158d606fd0aeeb073d62224" "dfca03ac1f2edbf642708af0992891cc93024aa8" "db382a13f6e22c79a09ffb69ca5a504dcf6c9bd5")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/tools/connector_client camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/tools/connector_client"

inherit cros-camera cros-workon platform

DESCRIPTION="A simple package that exercises cros-camera-libcamera_connector"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="chromeos-base/cros-camera-libs"

DEPEND="${RDEPEND}
	x11-libs/libdrm"

BDEPEND="virtual/pkgconfig"

src_install() {
	platform_src_install
	dobin "${OUT}/cros_camera_connector_client"
}
