# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="02005b48b1b6b6d6c426893eab618cf8d843beb0"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "4be8d3ae5664634825afc2e6e4b8c24816ee9b9e" "34c825a80bd71bac019bf7a5a2b2832c4c9ba3a9" "4e99b642c7d96f9309abd4ec2bcfa60369cf7b91" "29d52c6d2464057e3fde8214a173f96d96f3b267" "315e498c5d7c8235bee0deb98d4ea5f32810e761" "aae8bf048bbe1147ff2aa47f59de29bad1b6355d" "527abd7a988a45572305a6c44b5324d0d9cf8be2" "81608e81e7a1a6aacd7096a66fd44588c1d5ece9" "8a9ef8758fbc933dbbb61914e0a924d6fd9626f6" "b267b5e958c81afb5604e69f60fefaa5abcae43d")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# iioservice/ is included just to make sandbox happy when running `gn gen`.
CROS_WORKON_SUBTREE=".gn camera/build camera/features camera/include camera/gpu camera/common camera/mojo chromeos-config common-mk iioservice/libiioservice_ipc iioservice/mojo"
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
