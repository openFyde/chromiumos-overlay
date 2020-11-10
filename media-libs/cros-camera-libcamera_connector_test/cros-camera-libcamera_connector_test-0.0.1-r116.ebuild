# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="81ab653dea22fb44fdc89c7bda55319b5fa78cfd"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "0c5dd9314b371b69ea4c6552b948251370b301db" "85dcd31292e99125b2eb2744c83442e00dece79f" "deae25aff188ab5ba0e93e5a3b5dbdad82b01b02")
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
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_connector
	dev-cpp/gtest:=
	media-libs/libyuv
	virtual/jpeg:0"

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

src_install() {
	platform_src_install
	dobin "${OUT}/cros_camera_connector_test"
}
