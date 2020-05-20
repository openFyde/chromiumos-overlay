# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"aosp/platform/system/core/base"
	"aosp/platform/system/core/libcutils"
	"aosp/platform/system/core/libutils"
	"aosp/platform/system/libhidl"
)
CROS_WORKON_REPO=(
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
)
CROS_WORKON_LOCALNAME=(
	"platform2"
	"aosp/system/core/base"
	"aosp/system/core/libcutils"
	"aosp/system/core/libutils"
	"aosp/system/libhidl"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform2/aosp/system/core/base"
	"${S}/platform2/aosp/system/core/libcutils"
	"${S}/platform2/aosp/system/core/libutils"
	"${S}/platform2/aosp/system/libhidl"
)
CROS_WORKON_SUBTREE=(
	"common-mk nnapi .gn"
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
KEYWORDS="~*"
IUSE=""

RDEPEND="
"

DEPEND="
	${RDEPEND}
"

src_install() {
	einfo "Installing Android headers."
	insinto /usr/include/aosp
	doins -r includes/*
	doins -r ../aosp/system/core/base/include/*
	doins -r ../aosp/system/core/libcutils/include/*
	doins -r ../aosp/system/core/libutils/include/*
	doins -r ../aosp/system/libhidl/base/include/*
	doins -r ../aosp/system/libhidl/libhidlmemory/include/*

	einfo "Installing static libraries."
	dolib.a "${OUT}/libnnapi-base.a"
	dolib.a "${OUT}/libnnapi-cutils.a"
	dolib.a "${OUT}/libnnapi-utils.a"
}

platform_pkg_test() {
	local tests=(
		base cutils utils
	)

	local test_target
	for test_target in "${tests[@]}"; do
		platform_test "run" "${OUT}/libnnapi-${test_target}_testrunner"
	done
}
