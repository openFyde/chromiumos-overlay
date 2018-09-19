# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("fdf996d2a18b50880464c13549f83537f2efcab5" "6ff57fa38a9d7ef01f2eef93680aa515f5fdba98")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "5d9312be37030d88b1b912ec15b45a0127a88d53" "f62010221e3eb0566f97bc9fe74a5d47808c8cc4" "62e34ac946e6d1a95cc072d886d6a7087bb6c820" "db103a9dd2c79eed8075b58d7c1c4484354a1683")
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

