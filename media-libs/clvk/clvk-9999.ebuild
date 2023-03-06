# Copyright 2021 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

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
	"upstream/main"
	"upstream/main"
)

inherit cmake-utils cros-workon

CMAKE_USE_DIR="${CLVK_DIR}"

DESCRIPTION="Prototype implementation of OpenCL 1.2 on to of Vulkan using clspv as the Compiler"
HOMEPAGE="https://github.com/kpet/${PN}"

LLVM_FOLDER="llvm-project-88b9d1a49aba54171804da355f00c8fe0483f428"
LLVM_ARCHIVE="${LLVM_FOLDER}.zip"

SPIRV_LLVM_TRANSLATOR_FOLDER="SPIRV-LLVM-Translator-a836197d52aced43f49b7f9a2386424ce734acba"
SPIRV_LLVM_TRANSLATOR_ARCHIVE="${SPIRV_LLVM_TRANSLATOR_FOLDER}.zip"

SRC_URI="
https://storage.cloud.google.com/chromeos-localmirror/distfiles/${LLVM_ARCHIVE}
https://storage.cloud.google.com/chromeos-localmirror/distfiles/${SPIRV_LLVM_TRANSLATOR_ARCHIVE}
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~*"
IUSE="debug +perfetto"

# target build dependencies
DEPEND="
	>=dev-util/vulkan-headers-1.3.211
	>=dev-util/opencl-headers-2021.04.29
	>=dev-util/spirv-tools-1.3.211
	>=dev-util/spirv-headers-1.3.211-r1
"

# target runtime dependencies
RDEPEND="
	>=dev-util/spirv-tools-1.3.211
	>=media-libs/vulkan-loader-1.3.211
"

# host build dependencies
BDEPEND="
	>=dev-util/cmake-3.13.4
"

PATCHES=()
if [[ ${PV} != "9999" ]]; then
	PATCHES+=("${FILESDIR}/clvk-00-opencl12.patch")
	# TODO(b/227133185) : To be removed once llvm is updated (once mesa issue is fixed)
	PATCHES+=("${FILESDIR}/clspv-use-old-llvm.patch")
	# TODO(b/241788717) : To be remove once we have a proper implementation for it in clvk
	PATCHES+=("${FILESDIR}/clvk-01-sampledbuffer.patch")

	# TODO(b/259217927) : To be remove as soon as they are merged upstream
	PATCHES+=("${FILESDIR}/clvk-10-main-thread-exec.patch")
	PATCHES+=("${FILESDIR}/clvk-11-multi-command-event.patch")
	PATCHES+=("${FILESDIR}/clvk-90-timeline-semaphores.patch")
	PATCHES+=("${FILESDIR}/clvk-91-configurable-polling.patch")
fi

src_unpack() {
	unpack "${LLVM_ARCHIVE}"
	unpack "${SPIRV_LLVM_TRANSLATOR_ARCHIVE}"
	cros-workon_src_unpack
}

src_prepare() {
	# TODO(b/227133185) : To be removed once Intel fixed the issue in mesa breaking TFlite (and preventing llvm to be updated).
	pushd "${WORKDIR}/${LLVM_FOLDER}" || die
	eapply "${FILESDIR}/UPSTREAM-llvm-d8d793f29b4-Fix-compat-with-retroactive-c++23.patch"
	eapply "${FILESDIR}/UPSTREAM-llvm-b3dae59b9df-Fix-CodeGenAction-for-LLVM-IR-MemBuffers.patch"
	popd || die

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
	local CLVK_SPIRV_LLVM_TRANSLATOR_DIR="${WORKDIR}/${SPIRV_LLVM_TRANSLATOR_FOLDER}"
	local mycmakeargs=(
		-DSPIRV_HEADERS_SOURCE_DIR="${ESYSROOT}/usr/"
		-DSPIRV_TOOLS_SOURCE_DIR="${ESYSROOT}/usr/"

		-DLLVM_SPIRV_SOURCE="${CLVK_SPIRV_LLVM_TRANSLATOR_DIR}"
		-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="${SPIRV_HEADERS_SOURCE_DIR}"

		-DCLSPV_SOURCE_DIR="${CLSPV_DIR}"
		-DCLSPV_LLVM_SOURCE_DIR="${CLVK_LLVM_PROJECT_DIR}/llvm"
		-DCLSPV_CLANG_SOURCE_DIR="${CLVK_LLVM_PROJECT_DIR}/clang"

		-DCLVK_CLSPV_ONLINE_COMPILER=1

		-DCLSPV_BUILD_SPIRV_DIS=OFF
		-DCLSPV_BUILD_TESTS=OFF
		-DCLVK_BUILD_TESTS=OFF
		-DCLVK_BUILD_SPIRV_TOOLS=OFF

		-DCLVK_VULKAN_IMPLEMENTATION=system

		-DCMAKE_MODULE_PATH="${CMAKE_MODULE_PATH};${CLVK_LLVM_PROJECT_DIR}/llvm/cmake/modules"

		-DBUILD_SHARED_LIBS=OFF

		-DCLVK_ENABLE_ASSERTIONS=ON

		-DCLVK_PERFETTO_ENABLE=$(usex perfetto ON OFF)
		-DCLVK_PERFETTO_LIBRARY=perfetto_sdk
		-DCLVK_PERFETTO_BACKEND=System
		-DCLVK_PERFETTO_SDK_DIR="${ESYSROOT}/usr/include/perfetto/"
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
