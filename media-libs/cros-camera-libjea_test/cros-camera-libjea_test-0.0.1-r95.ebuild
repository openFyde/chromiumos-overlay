# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("869c0245afe68974aaadbf97e6b877a72eae3a3e" "762e1a8aeebc5d759e3c2240fce5a1a1f8341f57")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "469e9d0e025291b19f7d53e76b4544fc494e5326" "155980e1c2bd87fc6639347a774cfa3858c96903" "bfef2802b8fc411b9769b3112b451ad72ae0de7f" "f686c2461d2a814ae8615206c7cd73f46fa51482")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/arc-camera"
	"chromiumos/platform2"
)
CROS_WORKON_LOCALNAME=(
	"../platform/arc-camera"
	"../platform2"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/arc-camera"
	"${S}/platform2"
)
CROS_WORKON_SUBTREE=(
	"build common include mojo"
	"common-mk"
)
PLATFORM_GYP_FILE="common/jpeg/libjea_test.gyp"

inherit cros-camera cros-workon

DESCRIPTION="End to end test for JPEG encode accelerator"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	dev-cpp/gtest
	media-libs/cros-camera-libcamera_exif
	media-libs/cros-camera-libcamera_jpeg"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dobin "${OUT}/libjea_test"
}

