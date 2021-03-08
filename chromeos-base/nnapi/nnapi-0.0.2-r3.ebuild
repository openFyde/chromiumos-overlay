# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("a03802ee1856bd49ee34754519314e57c60afed6" "23e2bf511667b4fa5859812a4e7945c8638f6603" "f0d85f116fd745ed927bca0102a1040629e528c9" "c92d0857816b8694a74ba1a47b754563d4452f65" "b7f8cf0f0beab62bc5a391226ebd835c2fe377dc" "8e369832671de86e05cbbd3eeb7ddfe7df95f1ec" "6b79fa280312109216ce8b3a4893f266775cddc2" "e386a40d816e794c12040936608d252ab96077a7")
CROS_WORKON_TREE=("eaed4f3b0a8201ef3951bf1960728885ff99e772" "64b6839ee0c350c6387157eb82ce359c719646f1" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d0c498cd8aacda36a50685194a4f11a5538c36ec" "84e5da480e7ca644dd680845aadd3c35eef39972" "60d005eccb2f9431ea99a17d8637375a9e5e387d" "4007f79bbd89b30be582cb0cdb1292ce377f34e1" "077dba53acf2e9a7a56288ee75d515afa7541b94" "bcea173391bb1aa3b0978ecc33a27d447e59eb18" "6a8c1be1913e7a9ccf5141a072ad595a1e9d3add")
inherit cros-constants

CROS_WORKON_MANUAL_UPREV="1"

CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"aosp/platform/frameworks/native"
	"aosp/platform/system/core/libcutils"
	"aosp/platform/system/core/libutils"
	"aosp/platform/system/libbase"
	"aosp/platform/system/libfmq"
	"aosp/platform/system/libhidl"
	"aosp/platform/system/logging"
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
	"aosp/system/core/libutils"
	"aosp/system/libbase"
	"aosp/system/libfmq"
	"aosp/system/libhidl"
	"aosp/system/logging"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform2/aosp/frameworks/native"
	"${S}/platform2/aosp/system/core/libcutils"
	"${S}/platform2/aosp/system/core/libutils"
	"${S}/platform2/aosp/system/libbase"
	"${S}/platform2/aosp/system/libfmq"
	"${S}/platform2/aosp/system/libhidl"
	"${S}/platform2/aosp/system/logging"
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
	"${FILESDIR}/00009-libutils-timer-cast.patch"
	"${FILESDIR}/00010-libutils-clock-test.patch"
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
	eapply -p2 "${FILESDIR}/00009-libutils-timer-cast.patch"
	eapply -p2 "${FILESDIR}/00010-libutils-clock-test.patch"
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
	doins -r ../aosp/system/core/libutils/include/*
	doins -r ../aosp/system/libbase/include/*
	doins -r ../aosp/system/libfmq/include/*
	doins -r ../aosp/system/libfmq/base/*
	doins -r ../aosp/system/libhidl/base/include/*
	doins -r ../aosp/system/libhidl/libhidlmemory/include/*
	doins -r ../aosp/system/logging/liblog/include/*
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
		gtest_excl_filter+="SharedBufferTest.alloc_null:"
		gtest_excl_filter+="SharedBufferTest.editResize_null:"
		gtest_excl_filter+="SharedBufferTest.editResize_death:"

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
