# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("a72ae1e5d314b8516eaf1136238ef22b8323d5b3" "4effb50064a04a3b2394d8132f0544cf851107a4")
CROS_WORKON_TREE=("81f7fe23bf497aafef6d4128b33582b4422a9ff5" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "515ab32dfde6dabd0e67095b28d851c9a13f9a17")
inherit cros-constants

CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME=("../platform2" "../aosp/external/puffin")
CROS_WORKON_PROJECT=("chromiumos/platform2" "platform/external/puffin")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/puffin")
CROS_WORKON_REPO=("${CROS_GIT_HOST_URL}" "${CROS_GIT_AOSP_URL}")
CROS_WORKON_SUBTREE=("common-mk .gn" "")
CROS_WORKON_BLACKLIST=1

PLATFORM_SUBDIR="puffin"

inherit cros-workon platform

DESCRIPTION="Puffin: Deterministic patching tool for deflate streams"
HOMEPAGE="https://android.googlesource.com/platform/external/puffin/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="asan fuzzer"

COMMON_DEPEND="chromeos-base/libbrillo:=[asan?,fuzzer?]
	dev-libs/protobuf:=
	dev-util/bsdiff:=
"

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_install() {
	if use cros_host; then
		dobin "${OUT}"/puffin
	fi
	dolib.a "${OUT}"/libpuffpatch.a
	dolib.a "${OUT}"/libpuffdiff.a

	insinto /usr/include
	doins -r src/include/puffin

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins libpuffdiff.pc libpuffpatch.pc

	for f in "huff" "puff" "puffpatch"; do
		platform_fuzzer_install "${S}"/OWNERS "${OUT}/puffin_${f}_fuzzer"
	done
}

platform_pkg_test() {
	platform_test "run" "${OUT}/puffin_test"

	# Run fuzzers.
	for f in "huff" "puff" "puffpatch"; do
		platform_fuzzer_test "${OUT}/puffin_${f}_fuzzer"
	done
}
