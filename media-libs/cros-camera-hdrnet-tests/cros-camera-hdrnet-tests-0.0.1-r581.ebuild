# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ed2a9a5d855d5350306b977e5f8ff1902e7db4b9"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "e6c14f0c95273c8c5309ea5700d767f6d220c42f" "cca028a152e5133236b2b7dd8b97ca79660968c2" "685138f76c50eb0afee87b0c82fff51b8c6ae41c" "b017f83d28a29a971d1a48af35894ff14343d1f3" "546d612834bb46518d8ed157a8923c49016e2fb5" "57e0be63e6c4ad6628bf18e46d669329e5240e57" "5a857fb996a67f6c9781b916ba2d6076e9dcd0a6" "5be17ba0d331df49cda26486f5a3e5d5db8b480a" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "4c5172284b14b531b3792e06b4423c8ca5f888f9" "1df96416290731160d582fa8ffa8f156b2fbac53")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# iioservice/ is included just to make sandbox happy when running `gn gen`.
CROS_WORKON_SUBTREE=".gn camera/build camera/features camera/include camera/gpu camera/common camera/mojo chromeos-config common-mk iioservice/libiioservice_ipc iioservice/mojo ml_core ml_core/mojo"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/features/hdrnet/tests"

inherit cros-workon platform

DESCRIPTION="Chrome OS camera HDRnet integration tests"

LICENSE="BSD-Google"
KEYWORDS="*"

# 'ipu6' and 'ipu6ep' are passed to and used in BUILD.gn files.
IUSE="ipu6 ipu6ep"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	chromeos-base/cros-camera-android-deps:=
	chromeos-base/cros-camera-libs:=
	dev-cpp/benchmark:=
	dev-cpp/gtest:=
	media-libs/cros-camera-libfs:=
	virtual/opengles:=
"

DEPEND="${RDEPEND}
	x11-drivers/opengles-headers:=
"

src_configure() {
	cros_optimize_package_for_speed
	platform_src_configure
}
