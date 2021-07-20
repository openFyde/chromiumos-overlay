# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="3c86876d16d7cf08146172c7a16f5be23a7f325b"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "a9db923ed9d7e66024405ab4fdb8bbe178930040" "d6da18980970932242d64eb2b51646d6b9ffe8e6" "334c8e0caef41ce68b04849338004bd466bd75a5" "cc8ae75ea68e5c37c867b396c0540c8a109ed460")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/jpeg/libjea_test"

inherit cros-camera cros-workon platform

DESCRIPTION="End to end test for JPEG encode accelerator"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/cros-camera-android-deps
	chromeos-base/cros-camera-libs
	dev-cpp/gtest:=
	media-libs/libyuv"

DEPEND="${RDEPEND}"

src_install() {
	platform_src_install
	dobin "${OUT}/libjea_test"
}
