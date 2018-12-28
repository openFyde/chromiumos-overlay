# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("c8a0570a63e20f9f6babbbdf3e5b7815cbe2e2bf" "e0bae29dc4ca5e8bcdcc2baa62df9ed62b6a7045")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "2b88e2d40e45bd1c25c2fcfadd905ae25672af5a" "ba77c5fe85be3e986c2c1a6ee44658e57389ee78" "bfef2802b8fc411b9769b3112b451ad72ae0de7f" "4579be7c556e0cced9740e12f6f221e2f0440995")
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

