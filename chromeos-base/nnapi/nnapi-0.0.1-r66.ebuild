# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("6de9b290f6f9cbaa368654aa6f96572b8551ab82" "ed38697b9f8e4140802f13e3bb4e174bf7201eed" "a2753728d4f1bb7960b76d4cdd03a17afd4f5fd3" "8bdbfb1df38a18de1c4d029df5af67d3e6158a96" "d6b98f0d88a2cd5067037eb3abb736eb980e4675" "85e3eaa08634ad3a73167a0d0f814c64a4d76ec6" "ceff5e345ef65eccd261fdd940f3e4ca67a916ba" "ce343f293774d1d2f88fc4828a2dc45ff0981feb")
CROS_WORKON_TREE=("1c07dc76ec4881aeccc6c6151786dc26bf5f73c0" "eb2fb925eaa3f36ed4140d6ccd0c153ab4ca3b12" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d59698b9aacd42201a585bee90f33719caa6338b" "4256bcdd9e9435828bf8159d85af015450112aff" "9f2ca25b3100a571a717a4a4c94b9131d8cfcd9c" "ebab04f72e15304ca62e4c1092e3cdabf397c792" "56c14098806dda31ef167573b2137a7cde75033f" "dcbde0bbddc02dde72a15bbf5b890da2cc032cc9" "3e10262144e64652e5c70fe978e1d6bae433ab27")
inherit cros-constants

CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"aosp/platform/frameworks/native"
	"aosp/platform/system/core/base"
	"aosp/platform/system/core/libcutils"
	"aosp/platform/system/core/liblog"
	"aosp/platform/system/core/libutils"
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
	"aosp/system/core/base"
	"aosp/system/core/libcutils"
	"aosp/system/core/liblog"
	"aosp/system/core/libutils"
	"aosp/system/libfmq"
	"aosp/system/libhidl"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform2/aosp/frameworks/native"
	"${S}/platform2/aosp/system/core/base"
	"${S}/platform2/aosp/system/core/libcutils"
	"${S}/platform2/aosp/system/core/liblog"
	"${S}/platform2/aosp/system/core/libutils"
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
	doins -r ../aosp/system/core/base/include/*
	doins -r ../aosp/system/core/libcutils/include/*
	doins -r ../aosp/system/core/liblog/include/*
	doins -r ../aosp/system/core/libutils/include/*
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
