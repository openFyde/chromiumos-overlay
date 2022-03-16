# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=(
	"a64c0156eb61a51c3d17c14d0741ca27c742fda9"
	"f99809bdab1710846633b4ec24f5448263e75da7"
)

CROS_WORKON_TREE=(
	"a64c0156eb61a51c3d17c14d0741ca27c742fda9"
	"f99809bdab1710846633b4ec24f5448263e75da7"
)

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

LLVM_FOLDER="llvm-project-d7630b37ceb8d7032f133e0257724997e4cc76ec"
LLVM_ARCHIVE="${LLVM_FOLDER}.zip"
SRC_URI="https://storage.cloud.google.com/chromeos-localmirror/distfiles/${LLVM_ARCHIVE}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="debug"

# target build dependencies
DEPEND="
	>=dev-util/vulkan-headers-1.2.162
	>=dev-util/opencl-headers-2021.04.29
	>=dev-util/spirv-tools-2020.6
	dev-util/spirv-headers
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
	PATCHES+=("${FILESDIR}/clvk-CL_MEM_OBJECT_IMAGE1D_BUFFER.patch")
fi

src_unpack() {
	unpack "${LLVM_ARCHIVE}"
	cros-workon_src_unpack
}

src_prepare() {
	cmake-utils_src_prepare
	eapply_user
}

build_host_tools() {
	[[ "$#" -eq 2 ]] \
		|| die "build_host_tools called with the wrong number of arguments"
	local HOST_DIR="$1"
	local LLVM_DIR="$2"

	# Use host toolchain when building for the host.
	local CC=${CBUILD}-clang
	local CXX=${CBUILD}-clang++
	local CFLAGS=''
	local CXXFLAGS=''
	local LDFLAGS=''

	mkdir -p "${HOST_DIR}" || die

	cd "${HOST_DIR}" || die
	cmake -DLLVM_ENABLE_PROJECTS="clang" -G "Unix Makefiles" "${LLVM_DIR}" || die

	cd "${HOST_DIR}/utils/TableGen" || die
	emake
	[[ -x "${HOST_DIR}/bin/llvm-tblgen" ]] \
		|| die "${HOST_DIR}/bin/llvm-tblgen not found or usable"

	cd "${HOST_DIR}/tools/clang/utils/TableGen" || die
	emake
	[[ -x "${HOST_DIR}/bin/clang-tblgen" ]] \
		|| die "${HOST_DIR}/bin/clang-tblgen not found or usable"
}

src_configure() {
	CMAKE_BUILD_TYPE=$(usex debug Debug RelWithDebInfo)

	local CLVK_LLVM_PROJECT_DIR="${WORKDIR}/${LLVM_FOLDER}"
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

	if tc-is-cross-compiler; then
		local HOST_DIR="${WORKDIR}/host_tools"
		build_host_tools "${HOST_DIR}" "${CLVK_LLVM_PROJECT_DIR}/llvm"
		mycmakeargs+=(
			-DCMAKE_CROSSCOMPILING=ON
			-DLLVM_TABLEGEN="${HOST_DIR}/bin/llvm-tblgen"
			-DCLANG_TABLEGEN="${HOST_DIR}/bin/clang-tblgen"
		)
	fi

	cmake-utils_src_configure
}

src_install() {
	dolib.so "${BUILD_DIR}/libOpenCL.so"*
}
