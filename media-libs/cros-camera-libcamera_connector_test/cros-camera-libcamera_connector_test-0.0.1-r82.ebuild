# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="fda7723bb7a45184ab59d6f6ec0eed96d1264477"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "1e2b8e1ac62607a9b3ac0b5f73320030093ce594" "d6fa10cef5a85a2615e1273240c221a553b43cc3" "b6b10e03115551b69ba9e2502b15d5467adcd107")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcamera_connector_test"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera connector test."

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	media-libs/cros-camera-libcamera_connector
	dev-cpp/gtest:=
	media-libs/libyuv
	virtual/jpeg:0"

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

src_install() {
	dobin "${OUT}/cros_camera_connector_test"
}
