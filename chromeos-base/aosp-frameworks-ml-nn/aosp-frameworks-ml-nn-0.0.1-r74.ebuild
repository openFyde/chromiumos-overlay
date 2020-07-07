# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("a1b9a034138b73293749ad546a885d23ddba5f82" "f8410e9c934610d52c05056a67af8904c59c8c52")
CROS_WORKON_TREE=("eec5ce9cfadd268344b02efdbec7465fbc391a9e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "1a8d3e62a5dc262148d817db94558f548cf7d9ab")
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
	chromeos-base/nnapi:=
	dev-libs/openssl:=
	sci-libs/tensorflow:=
"

DEPEND="
	${RDEPEND}
	dev-libs/libtextclassifier
	>=dev-cpp/eigen-3
"

cros-debug-add-NDEBUG() {
	# Don't set NDEBUG, overriding from cros-debug eclass.
	# If this is set, tests will fail and is also explicitly checked in
	# runtime/test/RequireDebug.cpp
	use cros-debug || echo "Not doing append-cppflags -NDEBUG";
}

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
		local gtest_excl_filter="-"

		if ! use x86 && ! use amd64; then
			# When running in qemu, these tests freeze the emulator when hitting
			# EventFlag::wake from libfmq. The error printed is:
			# Error in event flag wake attempt: Function not implemented
			# This is a known issue, see:
			# https://chromium.googlesource.com/chromiumos/docs/+/master/testing/running_unit_tests.md#caveats
			gtest_excl_filter+="Flavor/ExecutionTest12.Wait/0:"
			gtest_excl_filter+="Flavor/ExecutionTest13.Wait/0:"
			gtest_excl_filter+="IntrospectionFlavor/ExecutionTest13.Wait/0:"
			gtest_excl_filter+="Unfenced/TimingTest.Test/12:"
			gtest_excl_filter+="Unfenced/TimingTest.Test/15:"
			gtest_excl_filter+="Unfenced/TimingTest.Test/18:"
			gtest_excl_filter+="Unfenced/TimingTest.Test/21:"
			gtest_excl_filter+="Unfenced/TimingTest.Test/24:"
			gtest_excl_filter+="ValidationTestCompilationForDevices_1.ExecutionTiming:"
			gtest_excl_filter+="ValidationTestCompilationForDevices_1.ExecutionSetTimeout:"
			gtest_excl_filter+="ValidationTestCompilationForDevices_1.ExecutionSetTimeoutMaximum:"
		fi

		platform_test "run" "${OUT}/${test_target}_testrunner" "0" "${gtest_excl_filter}"
	done
}

src_install() {
	dolib.so "${OUT}/lib/libneuralnetworks.so"

	if ! use vendor-nnhal ; then
		dolib.so "${OUT}/lib/libvendor-nn-hal.so"
	fi
}
