# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_MANUAL_UPREV="1"

CROS_WORKON_PROJECT=(
	"chromiumos/third_party/clvk"
	"chromiumos/third_party/clspv"
)

CROS_WORKON_LOCALNAME=(
	"clvk"
	"clspv"
)

CLVK_DIR="${S}/clvk"
CLSPV_DIR="${S}/clspv"

CROS_WORKON_DESTDIR=(
	"${CLVK_DIR}"
	"${CLSPV_DIR}"
)

CROS_WORKON_EGIT_BRANCH=(
	"upstream/master"
	"upstream/master"
)

inherit cmake-utils cros-workon

CMAKE_USE_DIR="${CLVK_DIR}"

DESCRIPTION="Prototype implementation of OpenCL 1.2 on to of Vulkan using clspv as the Compiler"
HOMEPAGE="https://github.com/kpet/${PN}"

LLVM_SHA1="dea76ccaf40f"
SRC_URI="https://storage.cloud.google.com/chromeos-localmirror/distfiles/llvm-project-clvk-${LLVM_SHA1}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~*"
IUSE="debug"

# target build dependencies
DEPEND="
	>=dev-util/vulkan-headers-1.2.162
	>=dev-util/opencl-headers-2021.04.29
	>=dev-util/spirv-tools-2020.6
	>=dev-util/spirv-headers-1.5.4.1
"

# target runtime dependencies
RDEPEND="
	>=dev-util/spirv-tools-2020.6
	>=media-libs/vulkan-loader-1.2.162
"

# host build dependencies
BDEPEND="
	>=dev-util/cmake-3.13.4
"

PATCHES=()
if [[ ${PV} != "9999" ]]; then
	PATCHES+=("${FILESDIR}/clvk-CL_MEM_USE_COPY_HOST_PTR.patch")
fi

src_unpack() {
	unpack "llvm-project-clvk-${LLVM_SHA1}.tgz"
	cros-workon_src_unpack
}

src_prepare() {
	cmake-utils_src_prepare
	eapply_user
}

src_configure() {
	CMAKE_BUILD_TYPE=$(usex debug Debug RelWithDebInfo)

	local CLVK_LLVM_PROJECT_DIR="${WORKDIR}/llvm-project"
	local mycmakeargs=(
		-DSPIRV_HEADERS_SOURCE_DIR="${ESYSROOT}/usr/"
		-DSPIRV_TOOLS_SOURCE_DIR="${ESYSROOT}/usr/"

		-DCLSPV_SOURCE_DIR="${CLSPV_DIR}"
		-DCLSPV_LLVM_SOURCE_DIR="${CLVK_LLVM_PROJECT_DIR}/llvm"
		-DCLSPV_CLANG_SOURCE_DIR="${CLVK_LLVM_PROJECT_DIR}/clang"

		-DCLVK_CLSPV_ONLINE_COMPILER=1

		-DCLSPV_BUILD_TESTS=OFF
		-DCLVK_BUILD_TESTS=OFF
		-DCLVK_BUILD_SPIRV_TOOLS=OFF

		-DCLVK_VULKAN_IMPLEMENTATION=system

		-DCMAKE_MODULE_PATH="${CMAKE_MODULE_PATH};${CLVK_LLVM_PROJECT_DIR}/llvm/cmake/modules"

		-DBUILD_SHARED_LIBS=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	dolib.so "${BUILD_DIR}/libOpenCL.so"*
}
