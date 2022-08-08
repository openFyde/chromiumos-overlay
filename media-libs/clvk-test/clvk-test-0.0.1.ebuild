# Copyright 2021 The ChromiumOS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="ad6d1b71dc6b351928b6c9e9d4d826e39fe2ea44"

CROS_WORKON_TREE="ad6d1b71dc6b351928b6c9e9d4d826e39fe2ea44"

CROS_WORKON_MANUAL_UPREV="1"

CROS_WORKON_PROJECT="chromiumos/third_party/clvk"

CROS_WORKON_LOCALNAME="clvk"

CLVK_DIR="${S}/clvk"

CROS_WORKON_DESTDIR="${CLVK_DIR}"

CROS_WORKON_EGIT_BRANCH="upstream/main"

inherit cmake-utils cros-workon

CMAKE_USE_DIR="${CLVK_DIR}/tests"

DESCRIPTION="Prototype implementation of OpenCL 1.2 on to of Vulkan using clspv as the Compiler"
HOMEPAGE="https://github.com/kpet/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="debug"

# target build dependencies
DEPEND="
	>=dev-util/opencl-headers-2021.04.29
	>=media-libs/clvk-0.0.1
	>=dev-cpp/gtest-1.10.0
"

# target runtime dependencies
RDEPEND="
	>=media-libs/clvk-0.0.1
"

# host build dependencies
BDEPEND="
	>=dev-util/cmake-3.13.4
"

PATCHES=()
if [[ ${PV} != "9999" ]]; then
	PATCHES+=("${FILESDIR}/clvk-gtest.patch")
fi

src_prepare() {
	cmake-utils_src_prepare
	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DCLVK_VULKAN_IMPLEMENTATION=system
		-DCLVK_COMPILER_AVAILABLE=ON
		-DBUILD_SHARED_LIBS=OFF
		-DCLVK_BUILD_STATIC_TESTS=OFF
		-DCMAKE_CXX_STANDARD_LIBRARIES="-lpthread" # needed for api_tests
	)
	cmake-utils_src_configure
}

src_install() {
	local OPENCL_TESTS_DIR="/usr/local/opencl"
	dodir "${OPENCL_TESTS_DIR}"
	exeinto "${OPENCL_TESTS_DIR}"
	doexe "${BUILD_DIR}/api_tests" "${BUILD_DIR}/simple_test"
}
