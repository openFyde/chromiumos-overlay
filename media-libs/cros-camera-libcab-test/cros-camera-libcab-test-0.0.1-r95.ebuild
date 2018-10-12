# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("36041bbdb99f49dfa60d1337684428ee536125a7" "45ebdc7d36c2cd451d5936d300b816aafc928a1a")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "6028cd9188022931b0d2737a1d688fec44e3078b" "f62010221e3eb0566f97bc9fe74a5d47808c8cc4" "5d76066514dca6a32e833620a997a659f7fb2fd0")
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
