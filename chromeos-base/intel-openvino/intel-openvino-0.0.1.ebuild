# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic git-r3

DESCRIPTION="Intel OpenVino Toolkit"
HOMEPAGE="https://github.com/openvinotoolkit/openvino"

LICENSE="Apache-2.0"
KEYWORDS="-* amd64"
IUSE="+clang"
SLOT="0"

RDEPEND="
"

DEPEND="
	${RDEPEND}
"

src_unpack() {
	EGIT_REPO_URI="https://github.com/openvinotoolkit/openvino.git" \
	EGIT_CHECKOUT_DIR="${S}" \
	EGIT_COMMIT="2022.3.0" \
	git-r3_src_unpack
}

src_prepare() {
	eapply "${FILESDIR}/0001-Enable-build-for-ChromeOS.patch"
	eapply "${FILESDIR}/0002-Fix-OpenVINO-2022.3.0-compile-issues.patch"
	eapply "${FILESDIR}/0003-GNA-changes.patch"
	cros_enable_cxx_exceptions
	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	cros_enable_cxx_exceptions
	append-flags "-frtti"

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/usr/local/"
		-DTARGET_OS_NAME="CHROMIUMOS"
		-DENABLE_OV_TF_FRONTEND=OFF
		-DENABLE_OV_ONNX_FRONTEND=OFF
		-DENABLE_OV_PADDLE_FRONTEND=OFF
		-DENABLE_INTEL_GPU=OFF
		-DENABLE_INTEL_GNA=ON
		-DENABLE_INTEL_MYRIAD_COMMON=OFF
		-DENABLE_MULTI=OFF
		-DDNNL_ENABLE_WORKLOAD="INFERENCE"
		-DENABLE_NCC_STYLE=OFF
		-DTHREADING=SEQ
		-DENABLE_PYTHON=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dolib.so ${S}/bin/intel64/${CMAKE_BUILD_TYPE}/libformat_reader.so

	exeinto /usr/local/bin
	doexe ${S}/bin/intel64/${CMAKE_BUILD_TYPE}/hello_query_device
	doexe ${S}/bin/intel64/${CMAKE_BUILD_TYPE}/benchmark_app
	doexe ${S}/bin/intel64/${CMAKE_BUILD_TYPE}/hello_classification
	doexe ${S}/bin/intel64/${CMAKE_BUILD_TYPE}/classification_sample_async
	doexe ${S}/bin/intel64/${CMAKE_BUILD_TYPE}/speech_sample

	into /usr/local
	dobin ${D}/usr/local/tools/compile_tool/compile_tool

}
