# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("3c92ceccdd76b9a4a7fbc3558990308151207ef9" "a457cc7a65c8cd23572df023e7eaf88e3f219a4e")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "2835984e4f7c26a6c0ad234cf5cd650a4b0b6266" "f62010221e3eb0566f97bc9fe74a5d47808c8cc4" "622fb2c6022cadd56f945e7964fc2352099a0337")
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
	"build common include"
	"common-mk"
)
PLATFORM_GYP_FILE="common/libcab_test.gyp"

inherit cros-camera cros-workon

DESCRIPTION="Test for camera algorithm bridge library"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	dev-cpp/gtest
	!media-libs/arc-camera3-libcab-test
	media-libs/cros-camera-libcab"

DEPEND="${RDEPEND}"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dobin "${OUT}/libcab_test"
	dolib.so "${OUT}/lib/libcam_algo.so"
}
