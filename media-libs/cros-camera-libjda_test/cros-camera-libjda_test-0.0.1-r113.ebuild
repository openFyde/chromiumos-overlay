# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("44c34946304cef80bc0335e3bd941b6b77dad83e" "df4b06f91cc3de2ae6e4394431f038b1daab1bb8")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "469e9d0e025291b19f7d53e76b4544fc494e5326" "155980e1c2bd87fc6639347a774cfa3858c96903" "bfef2802b8fc411b9769b3112b451ad72ae0de7f" "5bd6cd9b9f9aeb7b7134f50089b6b616d216c60f")
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
