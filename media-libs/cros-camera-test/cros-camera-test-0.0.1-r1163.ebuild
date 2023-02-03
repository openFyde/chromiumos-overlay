# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="cad767893109803dc3684d48c3957edc26d03a57"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "b2e91d28bd8bf88dfa717196bafb9cb5cc7c41ec" "adf8145078b84d8f028ddb38cdf5a46a661b0013" "cca028a152e5133236b2b7dd8b97ca79660968c2" "1f278221a140da65dbcc43dc504b10807efbde8c" "5a857fb996a67f6c9781b916ba2d6076e9dcd0a6")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE=".gn camera/build camera/camera3_test camera/common camera/include chromeos-config common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/camera3_test"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera HAL native test."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"

RDEPEND="
	>=chromeos-base/cros-camera-libs-0.0.1-r34:=
	chromeos-base/cros-camera-android-deps
	media-libs/libexif
	media-libs/libsync
	media-libs/minigbm
	virtual/jpeg:0"

DEPEND="${RDEPEND}
	dev-cpp/gtest:=
	media-libs/libyuv
	virtual/pkgconfig"
