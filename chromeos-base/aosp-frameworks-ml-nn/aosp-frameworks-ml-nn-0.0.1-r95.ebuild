# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("87eb95e94faeafcfe180ac27a5b6d641d38eece9" "2f77d75a52ef631c3b1f593f91b3b019c0b36c84")
CROS_WORKON_TREE=("5dfc8a56b24f9d6c8c01853992400151fbc6113a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "f287f30e608d58ca963a65a62a4276479bceb4e0")
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
IUSE="cpu_flags_x86_avx2 vendor-nnhal minimal-driver"

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
		append-cppflags "-D_Float16=__fp16"
		append-cxxflags "-Xclang -fnative-half-type"
		append-cxxflags "-Xclang -fallow-half-arguments-and-returns"
	fi
	if use minimal-driver; then
		append-cppflags "-DNNAPI_USE_MINIMAL_DRIVER"
	fi
	platform_src_configure
}

platform_pkg_test() {
	local tests=(
		chromeos common common_operations driver_cache runtime runtime_generated
	)

	# When running in qemu, these tests freeze the emulator when hitting
	# EventFlag::wake from libfmq. The error printed is:
	# Error in event flag wake attempt: Function not implemented
	# This is a known issue, see:
	# https://chromium.googlesource.com/chromiumos/docs/+/master/testing/running_unit_tests.md#caveats
	local qemu_gtest_excl_filter="-"
	qemu_gtest_excl_filter+="Flavor/ExecutionTest12.Wait/0:"
	qemu_gtest_excl_filter+="Flavor/ExecutionTest13.Wait/0:"
	qemu_gtest_excl_filter+="IntrospectionFlavor/ExecutionTest13.Wait/0:"
	qemu_gtest_excl_filter+="Unfenced/TimingTest.Test/12:"
	qemu_gtest_excl_filter+="Unfenced/TimingTest.Test/15:"
	qemu_gtest_excl_filter+="Unfenced/TimingTest.Test/18:"
	qemu_gtest_excl_filter+="Unfenced/TimingTest.Test/21:"
	qemu_gtest_excl_filter+="Unfenced/TimingTest.Test/24:"
	qemu_gtest_excl_filter+="ValidationTestBurst.BurstComputeBadCompilation:"
	qemu_gtest_excl_filter+="ValidationTestBurst.BurstComputeConcurrent:"
	qemu_gtest_excl_filter+="ValidationTestBurst.BurstComputeDifferentCompilations:"
	qemu_gtest_excl_filter+="ValidationTestBurst.BurstComputeNull:"
	qemu_gtest_excl_filter+="ValidationTestBurst.FreeBurstBeforeMemory:"
	qemu_gtest_excl_filter+="ValidationTestBurst.FreeMemoryBeforeBurst:"
	qemu_gtest_excl_filter+="ValidationTestCompilation.ExecutionUsability:"
	qemu_gtest_excl_filter+="ValidationTestCompilationForDevices_1.ExecutionTiming:"
	qemu_gtest_excl_filter+="ValidationTestCompilationForDevices_1.ExecutionSetTimeout:"
	qemu_gtest_excl_filter+="ValidationTestCompilationForDevices_1.ExecutionSetTimeoutMaximum:"

	local gtest_excl_filter="-"
	if use asan; then
		# Some tests do not correctly clean up the Exceution object and it is
		# left 'in-flight', which gets ignored by ANeuralNetworksExecution_free.
		# See b/161844605.
		# Look for 'passed an in-flight ANeuralNetworksExecution' in log output
		gtest_excl_filter+="Fenced/TimingTest.Test/2:"
		gtest_excl_filter+="Fenced/TimingTest.Test/19:"
		gtest_excl_filter+="Flavor/ExecutionTest10.Wait/1:"
		gtest_excl_filter+="Flavor/ExecutionTest10.Wait/2:"
		gtest_excl_filter+="Flavor/ExecutionTest10.Wait/4:"
		gtest_excl_filter+="Flavor/ExecutionTest11.Wait/1:"
		gtest_excl_filter+="Flavor/ExecutionTest11.Wait/2:"
		gtest_excl_filter+="Flavor/ExecutionTest11.Wait/4:"
		gtest_excl_filter+="Flavor/ExecutionTest12.Wait/1:"
		gtest_excl_filter+="Flavor/ExecutionTest12.Wait/2:"
		gtest_excl_filter+="Flavor/ExecutionTest12.Wait/4:"
		gtest_excl_filter+="Flavor/ExecutionTest13.Wait/1:"
		gtest_excl_filter+="Flavor/ExecutionTest13.Wait/2:"
		gtest_excl_filter+="Flavor/ExecutionTest13.Wait/4:"
		gtest_excl_filter+="IntrospectionFlavor/ExecutionTest13.Wait/1:"
		gtest_excl_filter+="IntrospectionFlavor/ExecutionTest13.Wait/2:"
		gtest_excl_filter+="IntrospectionFlavor/ExecutionTest13.Wait/4:"

		# This is due to a leak caused when copying the memory pools
		# into the request object in this test. lsan_suppressions doesn't
		# work due to the lack of /usr/bin/llvm-symbolizer, so just exclude.
		gtest_excl_filter+="ComplianceTest.DeviceMemory:"
	fi

	local test_target
	for test_target in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_target}_testrunner" "0" "${gtest_excl_filter}" "${qemu_gtest_excl_filter}"
	done
}

src_install() {
	dolib.so "${OUT}/lib/libneuralnetworks.so"

	if ! use vendor-nnhal ; then
		dolib.so "${OUT}/lib/libvendor-nn-hal.so"
	fi
}
