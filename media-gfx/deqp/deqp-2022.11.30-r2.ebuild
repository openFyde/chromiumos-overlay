# Copyright 2015 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils cros-sanitizers

DESCRIPTION="drawElements Quality Program - an OpenGL ES testsuite"
HOMEPAGE="https://github.com/KhronosGroup/VK-GL-CTS"

# This corresponds to a commit for the chosen tag/branch.
MY_DEQP_COMMIT='6024a88390942876147a88dce82bbed73b866c1b'

# When building the Vulkan CTS, dEQP requires that certain external
# dependencies be unpacked into the source tree. See ${S}/external/fetch_sources.py
# in the dEQP for the required dependencies. Upload these tarballs to the ChromeOS mirror too and
# update the manifest.
MY_AMBER_COMMIT='8b145a6c89dcdb4ec28173339dd176fb7b6f43ed'
MY_GLSLANG_COMMIT='7dda6a6347b0bd550e202942adee475956ef462a'
MY_JSONCPP_COMMIT='9059f5cad030ba11d37818847443a53918c327b1'
MY_SPIRV_TOOLS_COMMIT='b930e734ea198b7aabbbf04ee1562cf6f57962f0'
MY_SPIRV_HEADERS_COMMIT='b765c355f488837ca4c77980ba69484f3ff277f5'

SRC_URI="https://github.com/KhronosGroup/VK-GL-CTS/archive/${MY_DEQP_COMMIT}.tar.gz -> deqp-${MY_DEQP_COMMIT}.tar.gz
	https://github.com/KhronosGroup/glslang/archive/${MY_GLSLANG_COMMIT}.tar.gz -> glslang-${MY_GLSLANG_COMMIT}.tar.gz
	https://github.com/KhronosGroup/SPIRV-Tools/archive/${MY_SPIRV_TOOLS_COMMIT}.tar.gz -> SPIRV-Tools-${MY_SPIRV_TOOLS_COMMIT}.tar.gz
	https://github.com/KhronosGroup/SPIRV-Headers/archive/${MY_SPIRV_HEADERS_COMMIT}.tar.gz -> SPIRV-Headers-${MY_SPIRV_HEADERS_COMMIT}.tar.gz
	https://github.com/google/amber/archive/${MY_AMBER_COMMIT}.tar.gz -> amber-${MY_AMBER_COMMIT}.tar.gz
	https://github.com/open-source-parsers/jsoncpp/archive/${MY_JSONCPP_COMMIT}.tar.gz -> jsoncpp-${MY_JSONCPP_COMMIT}.tar.gz"

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

	mv "VK-GL-CTS-${MY_DEQP_COMMIT}/"* .
	# TODO(ihf): remove cat once deqp-runner supports references.
	cat android/cts/main/vk-master/*.txt | sort | uniq > android/cts/main/tmp_cat_vk-master.txt
	mkdir -p external/{amber,glslang,spirv-tools,spirv-headers}
	mv "amber-${MY_AMBER_COMMIT}" external/amber/src || die
	mv "jsoncpp-${MY_JSONCPP_COMMIT}" external/jsoncpp/src || die
	mv "glslang-${MY_GLSLANG_COMMIT}" external/glslang/src || die
	mv "SPIRV-Tools-${MY_SPIRV_TOOLS_COMMIT}" external/spirv-tools/src || die
	mv "SPIRV-Headers-${MY_SPIRV_HEADERS_COMMIT}" external/spirv-headers/src || die
}

src_prepare() {
	cros_enable_cxx_exceptions

	eapply "${FILESDIR}/dced98a4a-Prevent-warnings-from-Amber-failing-the-CTS-build.patch"

	cmake-utils_src_prepare
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
	newins "android/cts/main/egl-master.txt" "egl.txt"
	newins "android/cts/main/gles2-master.txt" "gles2.txt"
	newins "android/cts/main/gles3-master.txt" "gles3.txt"
	newins "android/cts/main/gles31-master.txt" "gles31.txt"
	if use vulkan; then
		# TODO(ihf): remove tmp_cat_vk-master.txt when deqp-runner understands
		# directory structure below again.
		newins "android/cts/main/tmp_cat_vk-master.txt" "vk.txt"
		#newins "android/cts/main/vk-master.txt" "vk.txt"
		#doins -r "android/cts/main/vk-master"
		#dosym "${deqp_dir}/caselists/vk-master" "${deqp_dir}/external/vulkancts/modules/vulkan/vk-master"
	fi
}
