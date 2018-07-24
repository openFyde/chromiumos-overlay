# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("7b47e30dc4f382c6c988b8a35461b0da777a3391" "d68fa1ec122fe581abcc2eefd1f004943b909d7c")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "743d220243a801114bf32893bd59865830667327" "7db7e0f493ad0b47165e64d5c78cf43c560326cc" "04d2f915e83148f85ce085e7ee18f2506ec85a47" "2fbf3369a444e70d6320c89efbced5d7ddf79efb")
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
