# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bd4c32798fe16cbeaf4cc647acd20bf473d6b84a"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "ff65ca0654f4ad010db90044a858e246d3a70bdd" "305aa149517595c8e46f4dd521e980375bab4b6f" "097b25b85b7dec4791de5338c0fd84f117363220" "b5413a1de5fea67b73a33d2bda74fdcfa0fb8ed6" "899497742071ca69c46bd11e06074e3e2f10909e" "8821bec7557652f636e7eed8ee7944b23b50b4b8" "0f8162ff9f6ac631d51015788a59900fa1190abd" "f063c143da4054868aadc5be54cc3a45415a698e" "8a9ef8758fbc933dbbb61914e0a924d6fd9626f6" "6c730fa6bc9c00d204b80c4944f1951b8f35a48e")
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
