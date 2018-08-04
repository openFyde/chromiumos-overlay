# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("3c73a3f03f43beaa02997ae888af32d004268b17" "eeb8540e200ef0b1821f5cbecd4c7cdb855fd223")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "743d220243a801114bf32893bd59865830667327" "15c6d2b3c8226508b7434556acbda449e788a508" "04d2f915e83148f85ce085e7ee18f2506ec85a47" "34d0c2012d9c10e37d0ea3794dabd2815e666ffc")
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

