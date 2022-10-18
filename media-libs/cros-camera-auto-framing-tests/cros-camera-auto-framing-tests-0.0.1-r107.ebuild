# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4444802f98c5b7e8d3ee5e6794b60f6a4c7f2ce5"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "89b0f131f6910f7ae898d02db7002d0485233e95" "44e72bbc38a5680e66be1b6c5862a62fd2a934f4" "69d594ef01f54f3b24556a6213c2e11634e5c631" "4a86cdeef3d62cc86c76c7ec778bb1bff8949cae" "813adba0493a14b6ffa15bc6b6affa1b052c2c95" "fefa46dc07b1045ed94377bd79f0ec4cac20f50a" "bbe1aadbe90ae34828c6b8a1e3b034d9cdd19662" "bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "7ddb8f962dd6611aef849f6a4c0ed7268cedb699" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "eb510d666a66e6125e281499b649651b849a25f7" "d59e71ccef5d54ff0d0d3d41a69aa70d60282d7a" "22ed84b6e53a60ef2db1dd92057fe643463c35bd")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# iioservice/ is included just to make sandbox happy when running `gn gen`.
CROS_WORKON_SUBTREE=".gn camera/build camera/features camera/include camera/gpu camera/common camera/mojo chromeos-config common-mk iioservice/libiioservice_ipc iioservice/mojo metrics ml_core ml_core/mojo"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/features/auto_framing/tests"

inherit cros-workon platform

DESCRIPTION="ChromeOS Camera Auto-framing feature tests"

LICENSE="BSD-Google"
KEYWORDS="*"

IUSE="camera_feature_auto_framing camera_feature_face_detection"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	chromeos-base/chromeos-config-tools:=
	chromeos-base/cros-camera-android-deps:=
	dev-cpp/gtest:=
	media-libs/cros-camera-libfs:=
	media-libs/libexif:=
	media-libs/libsync:=
	media-libs/minigbm:=
	virtual/opengles:=
	x11-libs/libdrm:=
"

DEPEND="
	${RDEPEND}
	chromeos-base/metrics:=
	media-libs/libyuv:=
	x11-drivers/opengles-headers:=
"

src_configure() {
	cros_optimize_package_for_speed
	platform_src_configure
}

src_install() {
	dobin "${OUT}"/auto_framing_test
	platform_src_install
}
