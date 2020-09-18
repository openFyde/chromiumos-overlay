# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("d9ce303db8aeedf029100616e9c5792674787473" "e9ef20b988f629406f6a8d7fe22ae5f006abdbd2" "8b529c2a6a966c93de4e89f08e746da4a4307e04" "357ba7427eb2b49467d39c09d57439fab3898467" "cce41c55319e81218ef5c6f1a322adcd249c5abb" "08495901b78c7c3d9a1a81e541897c2ec114fe34" "ceff5e345ef65eccd261fdd940f3e4ca67a916ba" "ce343f293774d1d2f88fc4828a2dc45ff0981feb")
CROS_WORKON_TREE=("825512278f3738ba8ac7c5f167aacd4677cfebf7" "799a18b3e192269829efc902ed9b430aa32cadb4" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "53a4656104a89df4072d3101327f51fcf6c9cbb2" "b4147760c8f1da9f6749f61748d2cacf89237717" "dc37c5c3ce7989055b7a2d5a2dcc5d605ee189d7" "078088f837cd0a9b1c3123b5d93904f4ec2f2af6" "cbb1596cd3157db5ffe44d03d24c30cc9ed53e38" "dcbde0bbddc02dde72a15bbf5b890da2cc032cc9" "3e10262144e64652e5c70fe978e1d6bae433ab27")
inherit cros-constants

CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"aosp/platform/frameworks/native"
	"aosp/platform/system/core/libcutils"
	"aosp/platform/system/core/liblog"
	"aosp/platform/system/core/libutils"
	"aosp/platform/system/libbase"
	"aosp/platform/system/libfmq"
	"aosp/platform/system/libhidl"
)
CROS_WORKON_REPO=(
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
)
CROS_WORKON_LOCALNAME=(
	"platform2"
	"aosp/frameworks/native"
	"aosp/system/core/libcutils"
	"aosp/system/core/liblog"
	"aosp/system/core/libutils"
	"aosp/system/libbase"
	"aosp/system/libfmq"
	"aosp/system/libhidl"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform2/aosp/frameworks/native"
	"${S}/platform2/aosp/system/core/libcutils"
	"${S}/platform2/aosp/system/core/liblog"
	"${S}/platform2/aosp/system/core/libutils"
	"${S}/platform2/aosp/system/libbase"
	"${S}/platform2/aosp/system/libfmq"
	"${S}/platform2/aosp/system/libhidl"
)
CROS_WORKON_SUBTREE=(
	"common-mk nnapi .gn"
	""
	""
	""
	""
	""
	""
	""
)

PLATFORM_SUBDIR="nnapi"

inherit cros-workon platform

DESCRIPTION="Chrome OS support utils for Android Neural Network API"
HOMEPAGE="https://developer.android.com/ndk/guides/neuralnetworks"

LICENSE="BSD-Google  Apache-2.0"
KEYWORDS="*"
IUSE=""

RDEPEND="
"

DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/00001-libbase-fix-stderr-logging.patch"
	"${FILESDIR}/00002-libhidl-callstack.patch"
	"${FILESDIR}/00003-libutils-callstack.patch"
	"${FILESDIR}/00004-libfmq-page-size.patch"
	"${FILESDIR}/00005-libcutils-ashmemtests.patch"
	"${FILESDIR}/00006-libhidl-cast-interface.patch"
	"${FILESDIR}/00007-libbase-get-property-from-envvar.patch"
	"${FILESDIR}/00008-libutils-memory-leak.patch"
)

src_prepare() {
	# The workdir is platform2/nnapi - we need to pop up one level in the stack
	# to apply our patches.
	pushd .. || exit
	eapply -p2 "${FILESDIR}/00001-libbase-fix-stderr-logging.patch"
	eapply -p2 "${FILESDIR}/00002-libhidl-callstack.patch"
	eapply -p2 "${FILESDIR}/00003-libutils-callstack.patch"
	eapply -p2 "${FILESDIR}/00004-libfmq-page-size.patch"
	eapply -p2 "${FILESDIR}/00005-libcutils-ashmemtests.patch"
	eapply -p2 "${FILESDIR}/00006-libhidl-cast-interface.patch"
	eapply -p2 "${FILESDIR}/00007-libbase-get-property-from-envvar.patch"
	eapply -p2 "${FILESDIR}/00008-libutils-memory-leak.patch"
	popd || exit

	eapply_user
}

src_install() {
	einfo "Installing Android headers."
	insinto /usr/include/aosp
	doins -r includes/*
	doins -r ../aosp/frameworks/native/libs/arect/include/*
	doins -r ../aosp/frameworks/native/libs/nativewindow/include/*
	doins -r ../aosp/system/core/libcutils/include/*
	doins -r ../aosp/system/core/liblog/include/*
	doins -r ../aosp/system/core/libutils/include/*
	doins -r ../aosp/system/libbase/include/*
	doins -r ../aosp/system/libfmq/include/*
	doins -r ../aosp/system/libhidl/base/include/*
	doins -r ../aosp/system/libhidl/libhidlmemory/include/*
	# Selectively install one off headers
	insinto /usr/include/aosp/android
	doins ../aosp/frameworks/native/include/android/sharedmem.h

	einfo "Installing the shared library."
	dolib.so "${OUT}/lib/libnnapi-support.so"

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}/obj/nnapi/libnnapi-support.pc"
}

platform_pkg_test() {
	local tests=(
		base cutils fmq hidl hwbuf log utils
	)

	# When running in qemu, these tests freeze the emulator when hitting
	# EventFlag::wake from libfmq. The error printed is:
	# Error in event flag wake attempt: Function not implemented
	# This is a known issue, see:
	# https://chromium.googlesource.com/chromiumos/docs/+/master/testing/running_unit_tests.md#caveats
	local qemu_gtest_excl_filter="-"
	qemu_gtest_excl_filter+="BlockingReadWrites.SmallInputTest1:"

	local gtest_excl_filter="-"
	if use asan; then
		# The sharedbuffer tests deliberately allocate too much memory:
		# AddressSanitizer: requested allocation size 0xfffffffffffffffe
		# We can't use allocator_may_return_null=1 as it prints a warning that the
		# toolchain considers an error.
		gtest_excl_filter+="SharedBufferTest.TestAlloc:"
		gtest_excl_filter+="SharedBufferTest.TestEditResize:"

		# ForkSafe leaves some threads running which results in warning printed:
		# ==26==Running thread 23 was not suspended. False leaks are possible.
		# Toolchain considers anything in the asan output as an error.
		gtest_excl_filter+="logging.ForkSafe:"

		# The queue created in this test cannot be deleted without crashing in
		# the hidl library. lsan_suppressions doesn't work due to the lack of
		# /usr/bin/llvm-symbolizer, so just exclude the test.
		gtest_excl_filter+="BadQueueConfig.QueueSizeTooLarge:"
	fi

	local test_target
	for test_target in "${tests[@]}"; do
		platform_test "run" "${OUT}/lib${test_target}_testrunner" "0" "${gtest_excl_filter}" "${qemu_gtest_excl_filter}"
	done
}
