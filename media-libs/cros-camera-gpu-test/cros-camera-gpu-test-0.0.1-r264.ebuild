# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3b111282f1324ec462d705372b441e28f6caefb9"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "56ebaba2bbb985bdfae612ea5533ddf02fdf1548" "dfca03ac1f2edbf642708af0992891cc93024aa8" "b5413a1de5fea67b73a33d2bda74fdcfa0fb8ed6" "f01918105d4fd88f49e1287e635df4c0f97b9e9b" "589372b673eac2125688c94181c9b91cb1a50f06")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/include camera/gpu camera/common common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/gpu/tests"

inherit cros-workon platform

DESCRIPTION="Chrome OS camera GPU-related tests"

LICENSE="BSD-Google"
KEYWORDS="*"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	chromeos-base/cros-camera-android-deps:=
	chromeos-base/cros-camera-libs:=
	dev-cpp/gtest:=
	virtual/opengles:=
"

DEPEND="${RDEPEND}
	x11-drivers/opengles-headers:=
"

src_configure() {
	cros_optimize_package_for_speed
	platform_src_configure
}

src_install() {
	dobin "${OUT}"/image_processor_test
	platform_src_install
}
