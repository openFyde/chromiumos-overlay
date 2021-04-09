# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="e2c31be2c6dea118b5f77bc9ec1f4f470abdf6e2"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "44f1ed774fc52ed97e051bade9c6065ec6c151ea" "97f7e6ca9be5fd78db7f4f1e5a7712f44d0493c5" "a54d2df3e8853d5a5f1e0854b36d8d850db3611e")
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
