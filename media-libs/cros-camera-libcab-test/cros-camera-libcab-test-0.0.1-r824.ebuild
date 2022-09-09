# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="fe1fbf1427b050611a486c9afa1d32d4cf48bb66"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "5fc34f384cd5fc6a13144a7f836f2371938bb8a6" "f386c5ad3b69b5be8dd06422610d7f81853224be" "c457b08fd133fa46cd7a5cd2f8b4c1a783ceca8a" "bfb6ecc4da4dc2d7aafa35ed314e5d2fb8f2f8a6")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcab_test"

inherit cros-camera cros-workon platform

DESCRIPTION="Test for camera algorithm bridge library"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/cros-camera-libs
	dev-cpp/gtest:="

DEPEND="${RDEPEND}"

src_install() {
	dobin "${OUT}/libcab_test"
	dolib.so "${OUT}/lib/libcam_algo_test.so"
}
