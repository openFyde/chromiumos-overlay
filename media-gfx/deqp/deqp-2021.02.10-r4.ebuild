# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils cros-sanitizers

DESCRIPTION="drawElements Quality Program - an OpenGL ES testsuite"
HOMEPAGE="https://android.googlesource.com/platform/external/deqp"

# This corresponds to a commit near ToT.
MY_DEQP_COMMIT='e58b0b2e5075855482dc7d9991b0db35f9afe0c4'

# To uprev deqp, follow these commands:
# wget https://android.googlesource.com/platform/external/deqp/+archive/${MY_DEQP_COMMIT}.tar.gz
# gsutil cp -a public-read deqp-${MY_DEQP_COMMIT}.tar.gz gs://chromeos-localmirror/distfiles/

# When building the Vulkan CTS, dEQP requires that certain external
# dependencies be unpacked into the source tree. See ${S}/external/fetch_sources.py
# in the dEQP for the required dependencies. Upload these tarballs to the ChromeOS mirror too and
# update the manifest.
MY_AMBER_COMMIT='4d0115cccfcb3b73d20b6513b1c40748e6403c50'
MY_GLSLANG_COMMIT='ffccefddfd9a02ec0c0b6dd04ef5e1042279c97f'
MY_SPIRV_TOOLS_COMMIT='cd590fa3341284cd6d1ee82366155786cfd44c96'
MY_SPIRV_HEADERS_COMMIT='104ecc356c1bea4476320faca64440cd1df655a3'

SRC_URI="https://android.googlesource.com/platform/external/deqp/+archive/${MY_DEQP_COMMIT}.tar.gz -> deqp-${MY_DEQP_COMMIT}.tar.gz
	https://github.com/KhronosGroup/glslang/archive/${MY_GLSLANG_COMMIT}.tar.gz -> glslang-${MY_GLSLANG_COMMIT}.tar.gz
	https://github.com/KhronosGroup/SPIRV-Tools/archive/${MY_SPIRV_TOOLS_COMMIT}.tar.gz -> SPIRV-Tools-${MY_SPIRV_TOOLS_COMMIT}.tar.gz
	https://github.com/KhronosGroup/SPIRV-Headers/archive/${MY_SPIRV_HEADERS_COMMIT}.tar.gz -> SPIRV-Headers-${MY_SPIRV_HEADERS_COMMIT}.tar.gz
	https://github.com/google/amber/archive/${MY_AMBER_COMMIT}.tar.gz -> amber-${MY_AMBER_COMMIT}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="-vulkan"

RDEPEND="
	virtual/opengles
	media-libs/minigbm
	media-libs/libpng
	vulkan? ( virtual/vulkan-icd )
"

DEPEND="${RDEPEND}
	x11-drivers/opengles-headers
	x11-libs/libX11
"

S="${WORKDIR}"

src_unpack() {
	default_src_unpack || die

	mkdir -p external/{amber,glslang,spirv-tools,spirv-headers}
	mv "amber-${MY_AMBER_COMMIT}" external/amber/src || die
	mv "glslang-${MY_GLSLANG_COMMIT}" external/glslang/src || die
	mv "SPIRV-Tools-${MY_SPIRV_TOOLS_COMMIT}" external/spirv-tools/src || die
	mv "SPIRV-Headers-${MY_SPIRV_HEADERS_COMMIT}" external/spirv-headers/src || die
}

src_prepare() {
	default
}

src_configure() {
	sanitizers-setup-env

	# See crbug.com/585712.
	append-lfs-flags

	local de_cpu=
	case "${ARCH}" in
		x86)   de_cpu='DE_CPU_X86';;
		amd64) de_cpu='DE_CPU_X86_64';;
		arm)   de_cpu='DE_CPU_ARM';;
		arm64) de_cpu='DE_CPU_ARM_64';;
		*) die "unknown ARCH '${ARCH}'";;
	esac

	# Tell cmake to not produce rpaths. crbug.com/585715.
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=1
		-DCMAKE_FIND_ROOT_PATH="${ROOT}"
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY
		-DDE_CPU="${de_cpu}"
		-DDEQP_TARGET=surfaceless
	)

	# Undefine direct link to use runtime loading.
	append-cxxflags "-UDEQP_EGL_DIRECT_LINK"
	append-cxxflags "-UDEQP_GLES2_DIRECT_LINK"
	append-cxxflags "-UEQP_GLES3_DIRECT_LINK"
	append-cxxflags "-DQP_SUPPORT_PNG=1"

	cmake-utils_src_configure
}

src_install() {
	# dEQP requires that the layout of its installed files match the layout
	# of its build directory. Otherwise the binaries cannot find the data
	# files.
	local deqp_dir="/usr/local/${PN}"

	# Install module binaries
	exeinto "${deqp_dir}/modules/egl"
	doexe "${BUILD_DIR}/modules/egl/deqp-egl"
	exeinto "${deqp_dir}/modules/gles2"
	doexe "${BUILD_DIR}/modules/gles2/deqp-gles2"
	exeinto "${deqp_dir}/modules/gles3"
	doexe "${BUILD_DIR}/modules/gles3/deqp-gles3"
	exeinto "${deqp_dir}/modules/gles31"
	doexe "${BUILD_DIR}/modules/gles31/deqp-gles31"
	if use vulkan; then
		exeinto "${deqp_dir}/external/vulkancts/modules/vulkan"
		doexe "${BUILD_DIR}/external/vulkancts/modules/vulkan/deqp-vk"
	fi

	# Install executors
	exeinto "${deqp_dir}/execserver"
	doexe "${BUILD_DIR}/execserver/execserver"
	doexe "${BUILD_DIR}/execserver/execserver-client"
	doexe "${BUILD_DIR}/execserver/execserver-test"
	exeinto "${deqp_dir}/executor"
	doexe "${BUILD_DIR}/executor/executor"
	doexe "${BUILD_DIR}/executor/testlog-to-xml"

	# Install data files
	insinto "${deqp_dir}/modules/gles2"
	doins -r "${BUILD_DIR}/modules/gles2/gles2"
	insinto "${deqp_dir}/modules/gles3"
	doins -r "${BUILD_DIR}/modules/gles3/gles3"
	insinto "${deqp_dir}/modules/gles31"
	doins -r "${BUILD_DIR}/modules/gles31/gles31"
	if use vulkan; then
		insinto "${deqp_dir}/external/vulkancts/modules/vulkan"
		doins -r "${BUILD_DIR}/external/vulkancts/modules/vulkan/vulkan"
	fi
	insinto "${deqp_dir}"
	doins -r "doc/testlog-stylesheet"

	# Install caselists
	insinto "${deqp_dir}/caselists"
	newins "android/cts/master/egl-master.txt" "egl.txt"
	newins "android/cts/master/gles2-master.txt" "gles2.txt"
	newins "android/cts/master/gles3-master.txt" "gles3.txt"
	newins "android/cts/master/gles31-master.txt" "gles31.txt"
	if use vulkan; then
		newins "android/cts/master/vk-master.txt" "vk.txt"
	fi
}
