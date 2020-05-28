# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("31652d4d9d4c009a5c7d6613c4291b1dd0afc024" "5b15f32a101c1fea708ba9fc0f16b1fa43d3e5fb")
CROS_WORKON_TREE=("6eabf6c16a6c482fcc6c234aa5f1e36293a9b92e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "4ef58bc993f2d7fbfa7f70131606679eb3147610")
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
	>=dev-cpp/eigen-3
"

src_configure() {
	if use x86 || use amd64; then
		append-cxxflags "-D_Float16=__fp16"
		append-cxxflags "-Xclang=-fnative_half-type"
		append-cxxflags "-Xclang=-fallow-half-arguments-and-returns"
	fi
	if use cpu_flags_x86_avx2; then
		append-cxxflags "-mavx2 -mfma"
	fi
	platform_src_configure
}

platform_pkg_test() {
	local tests=(
		chromeos
	)

	local test_target
	for test_target in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_target}_testrunner"
	done
}
