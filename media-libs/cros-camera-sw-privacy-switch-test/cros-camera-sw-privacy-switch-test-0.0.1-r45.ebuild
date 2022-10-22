# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="53d36742fa7739aaba1ebc130282b4023b35856a"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "89b0f131f6910f7ae898d02db7002d0485233e95" "59d7bc271bdc0657f27e2bd1a3313194860a494d" "1506721f3569bfd4063a2a5e192123272107f2d5" "4a86cdeef3d62cc86c76c7ec778bb1bff8949cae" "69d594ef01f54f3b24556a6213c2e11634e5c631" "fefa46dc07b1045ed94377bd79f0ec4cac20f50a" "898824f4045fe5e638d817e6a9baa0c243470d69" "bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "7ddb8f962dd6611aef849f6a4c0ed7268cedb699" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "eb510d666a66e6125e281499b649651b849a25f7" "d59e71ccef5d54ff0d0d3d41a69aa70d60282d7a" "22ed84b6e53a60ef2db1dd92057fe643463c35bd")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# iioservice/ is included just to make sandbox happy when running `gn gen`.
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/features camera/gpu camera/include camera/mojo chromeos-config common-mk iioservice/libiioservice_ipc iioservice/mojo metrics ml_core ml_core/mojo"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/sw_privacy_switch_test"

inherit cros-workon platform

DESCRIPTION="ChromeOS Camera SW privacy switch test"

LICENSE="BSD-Google"
KEYWORDS="*"

IUSE=""

BDEPEND="virtual/pkgconfig"

RDEPEND="
	chromeos-base/chromeos-config-tools:=
	chromeos-base/cros-camera-android-deps:=
	chromeos-base/cros-camera-libs:=
	chromeos-base/metrics:=
	dev-cpp/gtest:=
	media-libs/libyuv:=
"

DEPEND="
	${RDEPEND}
"

src_configure() {
	# This is necessary for CameraBufferManagerImpl::AllocateScopedBuffer to
	# succeed. Without this, gbm_bo_create will fail.
	cros_optimize_package_for_speed
	platform_src_configure
}
