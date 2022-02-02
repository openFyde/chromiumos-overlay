# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a64c0156eb61a51c3d17c14d0741ca27c742fda9"

CROS_WORKON_TREE="a64c0156eb61a51c3d17c14d0741ca27c742fda9"

CROS_WORKON_MANUAL_UPREV="1"

CROS_WORKON_PROJECT="chromiumos/third_party/clvk"

CROS_WORKON_LOCALNAME="clvk"

CLVK_DIR="${S}/clvk"

CROS_WORKON_DESTDIR="${CLVK_DIR}"

CROS_WORKON_EGIT_BRANCH="upstream/master"

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
	>=dev-util/spirv-tools-2020.6
	>=media-libs/vulkan-loader-1.2.162
	>=media-libs/clvk-0.0.1
"

# host build dependencies
BDEPEND="
	>=dev-util/cmake-3.13.4
"

PATCHES=()
if [[ ${PV} != "9999" ]]; then
	PATCHES+=("${FILESDIR}/cmake.patch")
fi

src_prepare() {
	cmake-utils_src_prepare
	eapply_user
}

src_configure() {
	CMAKE_BUILD_TYPE=$(usex debug Debug RelWithDebInfo)

	local mycmakeargs=(
		-DCLVK_VULKAN_IMPLEMENTATION=system
		-DCLVK_COMPILER_AVAILABLE=ON
	)
	cmake-utils_src_configure
}

src_install() {
	local OPENCL_TESTS_DIR="/usr/local/opencl"
	dodir "${OPENCL_TESTS_DIR}"
	exeinto "${OPENCL_TESTS_DIR}"
	doexe "${BUILD_DIR}/api_tests" "${BUILD_DIR}/simple_test"
}
