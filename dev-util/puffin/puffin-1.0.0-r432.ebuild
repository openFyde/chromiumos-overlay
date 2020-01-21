# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("16870e83dd661349c32fcc764919cf31b22c8aca" "3204c84e377af6ae27377200d6c06a68037269a5")
CROS_WORKON_TREE=("34e736b2ee0acc1681bb3c37947454b3459bea88" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "2b901bb0f259cf17c53faa17538aa8d7a5b12df2")
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
