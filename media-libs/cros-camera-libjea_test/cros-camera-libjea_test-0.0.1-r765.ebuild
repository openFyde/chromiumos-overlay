# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="e616bb3462b7371620a0cdec5bd0f6908f9a4972"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "bdce8a305b6af438503ba12680e7d8526bcc2dfc" "8186ff7d928d650af8b35ecadd53ff47d71260ad" "05d06105393bce50730b6d7e4caaa8bc431e5723" "32b4e8dd008b53110288d6ab187104a92b405c89")
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
