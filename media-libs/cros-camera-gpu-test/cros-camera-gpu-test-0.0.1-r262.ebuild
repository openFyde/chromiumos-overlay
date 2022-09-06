# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bd4c32798fe16cbeaf4cc647acd20bf473d6b84a"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "ff65ca0654f4ad010db90044a858e246d3a70bdd" "097b25b85b7dec4791de5338c0fd84f117363220" "b5413a1de5fea67b73a33d2bda74fdcfa0fb8ed6" "899497742071ca69c46bd11e06074e3e2f10909e" "f063c143da4054868aadc5be54cc3a45415a698e")
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
