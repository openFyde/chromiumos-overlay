# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3 flag-o-matic

DESCRIPTION="Intel OpenVino Toolkit"
HOMEPAGE="https://github.com/openvinotoolkit/openvino"

CMAKE_BUILD_TYPE="Debug"
LICENSE="BSD-Google"
KEYWORDS="-* amd64"
IUSE="+clang"
SLOT="0"

RDEPEND="
	chromeos-base/intel-gnalib
"

DEPEND="
	${RDEPEND}
"

src_unpack() {
	EGIT_REPO_URI="https://github.com/RavirajSitaram/openvino.git" \
	EGIT_CHECKOUT_DIR="${S}" \
	EGIT_COMMIT="11a0fa96db25f96ef79ca03daf602536e818ecc3" \
	EGIT_BRANCH="optimized" \
	git-r3_src_unpack
}


src_configure() {
	cros_enable_cxx_exceptions
	append-flags "-frtti -msse4.2"
	CPPFLAGS="-I${S}/ngraph/src -I${S}/inference_engine/ngraph_ops ${CPPFLAGS}"
	CMAKE_BUILD_TYPE="Release"

	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DENABLE_CLDNN=OFF
		-DENABLE_GNA=ON
		-DGNA_LIBRARY_VERSION=GNA2
		-DENABLE_NGRAPH=OFF
		-DTHREADING=SEQ
		-DENABLE_MKL_DNN=OFF
		-DGNA_DIR="gna"
		-DTARGET_OS="CHROMEOS"
		-DENABLE_OPENCV=OFF
		-DENABLE_SAMPLES=OFF
		-DCMAKE_INSTALL_PREFIX="/usr/local"
		-DBUILD_SHARED_LIBS=ON
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dolib.so "${D}"/usr/local/deployment_tools/inference_engine/lib/intel64/libinference_engine.so
	dolib.so "${D}"/usr/local/deployment_tools/inference_engine/lib/intel64/libinference_engine_nn_builder.so
	dolib.so "${D}"/usr/local/deployment_tools/inference_engine/lib/intel64/libinference_engine_preproc.so
	dolib.so "${D}"/usr/local/deployment_tools/inference_engine/lib/intel64/libGNAPlugin.so
	dolib.so "${D}"/usr/local/deployment_tools/inference_engine/lib/intel64/libinference_engine_c_api.so
	dolib.so "${D}"/usr/local/deployment_tools/inference_engine/lib/intel64/plugins.xml
}
