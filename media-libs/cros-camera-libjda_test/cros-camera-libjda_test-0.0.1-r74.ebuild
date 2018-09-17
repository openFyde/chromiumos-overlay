# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("995c408f4685e9d08249a78d838d315914de2ebc" "a0597068cff9416cc8b7dab3f04b762115745a9b")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "49abb24bed5fdb6d528d44ee7fa66e1cdb0b84af" "15c6d2b3c8226508b7434556acbda449e788a508" "62e34ac946e6d1a95cc072d886d6a7087bb6c820" "8fba30151826c1dcd4a657503adc65a1c2a45da2")
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
