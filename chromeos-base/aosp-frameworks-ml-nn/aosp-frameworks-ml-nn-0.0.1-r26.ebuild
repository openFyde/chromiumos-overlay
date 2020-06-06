# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("8cb36ab0d6246a9f66fae74f6484ba5bf9364a10" "c8b5e349324ff5660dcb212221fbf6b4f3ad87a9")
CROS_WORKON_TREE=("4c23cb26be092f90ba8160118d643548e3a14a89" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "fe829c23ef2ebca959e256d9f0505ea1174351c2")
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
IUSE="cpu_flags_x86_avx2"

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
		chromeos runtime
	)

	local test_target
	for test_target in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_target}_testrunner"
	done
}

src_install() {
	dolib.so "${OUT}/lib/libneuralnetworks.so"
}
