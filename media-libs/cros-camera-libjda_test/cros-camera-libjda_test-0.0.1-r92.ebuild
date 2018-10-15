# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("e5a2d19a376463d8f39ff61ab1ebb425660be916" "ba8bd67e0e4d81f0468fe4f259d8a7e79306dd6a")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "6028cd9188022931b0d2737a1d688fec44e3078b" "f62010221e3eb0566f97bc9fe74a5d47808c8cc4" "62e34ac946e6d1a95cc072d886d6a7087bb6c820" "190c4cfe4984640ab62273e06456d51a30cfb725")
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
PLATFORM_GYP_FILE="common/jpeg/libjda_test.gyp"

inherit cros-camera cros-workon

DESCRIPTION="End to end test for JPEG decode accelerator"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="dev-cpp/gtest"

DEPEND="${RDEPEND}
	media-libs/cros-camera-libjda"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dobin "${OUT}/libjda_test"
}
