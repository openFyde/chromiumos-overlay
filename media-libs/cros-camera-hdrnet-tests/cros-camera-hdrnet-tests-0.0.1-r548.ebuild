# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="993784368c1234ccd4070d0eb043130bac9aa640"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "0f95a874b73bb49b327f1f4de697fb4bfc83d313" "c901c5ae2c93caaacd85170e42bc7275c199450f" "7010a5d9405cc702f23ac245cff1c1a7a877ad4e" "6371439c88fec493e01f27d7996bdb8f0f8151bc" "a0af00390c3d3c63903578edd1d7c7cb504a8699" "4a6e4c4f4458a2479859e637c02b0ae6deb9ea16" "6a36baaa49726ee92adcded5d7a9c28124985e9a" "7ddb8f962dd6611aef849f6a4c0ed7268cedb699" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "852e3fb47c6c7bc3baf28d7cb71766ea4aeee96e" "1df96416290731160d582fa8ffa8f156b2fbac53")
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
