# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("2a2b0046d672cce8f7f715913f96498a1b27784c" "ca937b5dd7fe354c288f354903654f85da548315" "e5c1dfc419bec2f682a9c17a4f8d75cabd69f848")
CROS_WORKON_TREE=("55c3467f43d24a0d99c27d8e9e417502a8aecede" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "b51e097c1127c4a9fa83ddbcc88b5d4d5f95a60f" "bbf597e1cd2e3f49a8a2aab9f85c903867311558")
inherit cros-constants

CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"aosp/platform/frameworks/ml"
	"aosp/platform/hardware/interfaces/neuralnetworks"
)
CROS_WORKON_REPO=(
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
)
CROS_WORKON_LOCALNAME=(
	"platform2"
	"aosp/frameworks/ml"
	"aosp/hardware/interfaces/neuralnetworks"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform2/aosp/frameworks/ml"
	"${S}/platform2/aosp/hardware/interfaces/neuralnetworks"
)
CROS_WORKON_SUBTREE=(
	"common-mk .gn"
	"nn"
	""
)

PLATFORM_SUBDIR="aosp/frameworks/ml/nn"

inherit cros-workon platform flag-o-matic

DESCRIPTION="Chrome OS port of the Android Neural Network API"
HOMEPAGE="https://developer.android.com/ndk/guides/neuralnetworks"

LICENSE="BSD-Google Apache-2.0"
KEYWORDS="*"
IUSE="cpu_flags_x86_avx2 vendor-nnhal minimal-driver nnapi_driver_tests"

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
		chromeos common driver_cache runtime runtime_generated
	)

	# When running in qemu, these tests freeze the emulator when hitting
	# EventFlag::wake from libfmq. The error printed is:
	# Error in event flag wake attempt: Function not implemented
	# This is a known issue, see:
	# https://chromium.googlesource.com/chromiumos/docs/+/master/testing/running_unit_tests.md#caveats
	# TODO(http://crbug.com/1117470): tracking bug for qemu fix
	local qemu_gtest_excl_filter="-"
	qemu_gtest_excl_filter+="Flavor/ExecutionTest10.Wait/*:"
	qemu_gtest_excl_filter+="Flavor/ExecutionTest11.Wait/*:"
	qemu_gtest_excl_filter+="Flavor/ExecutionTest12.Wait/*:"
	qemu_gtest_excl_filter+="Flavor/ExecutionTest13.Wait/*:"
	qemu_gtest_excl_filter+="IntrospectionFlavor/ExecutionTest13.Wait/*:"
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
		# Some tests do not correctly clean up the Execution object and it is
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

		# TODO(b/163081732): Fix tests that freeze in asan (jmpollock)
		# Now we have a situation where these tests are hanging in asan, but I can't
		# reproduce this locally (Flavor/ExecutionTest13.Wait/0).
		# The duplication to the above is intentional, as fixing this issue will not
		# fix the one above.
		gtest_excl_filter+="Flavor/ExecutionTest10.Wait/*:"
		gtest_excl_filter+="Flavor/ExecutionTest11.Wait/*:"
		gtest_excl_filter+="Flavor/ExecutionTest12.Wait/*:"
		gtest_excl_filter+="Flavor/ExecutionTest13.Wait/*:"
		gtest_excl_filter+="IntrospectionFlavor/ExecutionTest13.Wait/*:"

		# This is due to a leak caused when copying the memory pools
		# into the request object in this test. lsan_suppressions doesn't
		# work due to the lack of /usr/bin/llvm-symbolizer, so just exclude.
		gtest_excl_filter+="ComplianceTest.DeviceMemory:"
		gtest_excl_filter+="ValidateRequestTest.ScalarOutput:"
		gtest_excl_filter+="ValidateRequestTest.UnknownOutputRank:"

		# Disable asan container overflow checks that are coming from gtest,
		# not our code. Strangely this only started happening once we made
		# common a shared library.
		# See: https://crbug.com/1067977, https://crbug.com/1069722
		# https://github.com/google/sanitizers/wiki/AddressSanitizerContainerOverflow#false-positives
		export ASAN_OPTIONS+=":detect_container_overflow=0:"
	fi

	local test_target
	for test_target in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_target}_testrunner" "0" "${gtest_excl_filter}" "${qemu_gtest_excl_filter}"
	done
}

src_install() {
	einfo "Installing runtime & common Headers."
	insinto /usr/include/aosp/frameworks/ml/nn/common
	doins -r "${S}"/common/include
	insinto /usr/include/aosp/frameworks/ml/nn/runtime
	doins -r "${S}"/runtime/include

	einfo "Installing libs."
	dolib.so "${OUT}/lib/libneuralnetworks.so"
	dolib.so "${OUT}/lib/libnn-common.so"

	if ! use vendor-nnhal ; then
		einfo "Installing reference vendor hal."
		dolib.so "${OUT}/lib/libvendor-nn-hal.so"
	fi

	if use nnapi_driver_tests; then
		einfo "Installing hal driver tests."
		dobin "${OUT}/cros_nnapi_vts_1_0"
		dobin "${OUT}/cros_nnapi_vts_1_1"
		dobin "${OUT}/cros_nnapi_vts_1_2"
		dobin "${OUT}/cros_nnapi_vts_1_3"
		dobin "${OUT}/cros_nnapi_cts"
	fi
}
