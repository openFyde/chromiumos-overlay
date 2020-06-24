# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("e8999b134ae1f3a266907195001894ff1b5b2f3e" "067ac5d386c2a2598f4c832af34f64cbdb79eaf3")
CROS_WORKON_TREE=("eec5ce9cfadd268344b02efdbec7465fbc391a9e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "a07da10c6f0324057dcba5f7f2e3d0c4a3185d6f")
CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"aosp/platform/frameworks/ml"
)
CROS_WORKON_REPO=(
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
)
CROS_WORKON_LOCALNAME=(
	"platform2"
	"aosp/frameworks/ml"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform2/aosp/frameworks/ml"
)
CROS_WORKON_SUBTREE=(
	"common-mk .gn"
	"nn"
)

PLATFORM_SUBDIR="aosp/frameworks/ml/nn"

inherit cros-workon platform flag-o-matic

DESCRIPTION="Chrome OS port of the Android Neural Network API"
HOMEPAGE="https://developer.android.com/ndk/guides/neuralnetworks"

LICENSE="BSD-Google Apache-2.0"
KEYWORDS="*"
IUSE="cpu_flags_x86_avx2 vendor-nnhal"

RDEPEND="
	dev-libs/openssl:=
	sci-libs/tensorflow:=
"

DEPEND="
	${RDEPEND}
	chromeos-base/nnapi
	dev-libs/libtextclassifier
	>=dev-cpp/eigen-3
"

src_configure() {
	if use x86 || use amd64; then
		append-cxxflags "-D_Float16=__fp16"
		append-cxxflags "-Xclang -fnative-half-type"
		append-cxxflags "-Xclang -fallow-half-arguments-and-returns"
	fi
	platform_src_configure
}

platform_pkg_test() {
	local tests=(
		chromeos common common_operations driver_cache runtime runtime_generated
	)

	local test_target
	for test_target in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_target}_testrunner"
	done
}

src_install() {
	dolib.so "${OUT}/lib/libneuralnetworks.so"

	if ! use vendor-nnhal ; then
		dolib.so "${OUT}/lib/libvendor-nn-hal.so"
	fi
}
