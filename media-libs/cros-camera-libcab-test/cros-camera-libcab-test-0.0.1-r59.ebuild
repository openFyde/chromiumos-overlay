# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("5584f0c8f2f8fc61278e2e31af4e7aac6b9cf53b" "ddad9d0b8f0f0ab80b03c37b06b33efb67a78bc8")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "8b9abfa9a754f08aafd2822c1ed32b90927db47a" "15c6d2b3c8226508b7434556acbda449e788a508" "45463f6780972e10b5979ed201843a5dd6e93b53")
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
