# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("056cc008961096607b355d6efb169b5be4e5f4d0" "5f8bb68b31016172152ad3cade63e085ec60680d")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "b13ecfe59d89499092d4325f309ff6f87ba80f3a" "9c2d57f35528e62d4d73f405ad0800ea16aba9f0" "c7c53e5e73240826942d7edceef245b060e54ac7")
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
