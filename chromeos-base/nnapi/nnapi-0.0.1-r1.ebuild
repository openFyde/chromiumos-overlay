# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("0496d653d0a176e09489af48a55b65569964da33" "a2753728d4f1bb7960b76d4cdd03a17afd4f5fd3" "8b529c2a6a966c93de4e89f08e746da4a4307e04" "cce41c55319e81218ef5c6f1a322adcd249c5abb" "911852c231f779d1aee1e759c146e63f05e00d8f")
CROS_WORKON_TREE=("2117aff37f7d1324e283d78595a793c34f98ca7c" "633e138f2d6587af95e1cfe842db38d9cd19d43b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "4256bcdd9e9435828bf8159d85af015450112aff" "b4147760c8f1da9f6749f61748d2cacf89237717" "078088f837cd0a9b1c3123b5d93904f4ec2f2af6" "43a23f8182e90441b011501ddd6b5284200552b0")
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
KEYWORDS="*"
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
	doins -r ../aosp/system/core/libcutils/include/*

	einfo "Installing static libraries."
	dolib.a "${OUT}/libcutils.a"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/libcutils_testrunner"
}
