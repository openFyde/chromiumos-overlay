# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=6

CROS_WORKON_COMMIT=("80c7b00e09f0505d39a7848e8e8311a7c6574d85" "dfec7fab93efd097fa494268d0e60e7e115dcea7")
CROS_WORKON_TREE=("b669d122c480efd9e29ebcc55e0cb1959318dae3" "9b31a005af654c8d652f4aebebf840cfb42879c8")
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
SLOT="0"
KEYWORDS="*"
IUSE="asan fuzzer"

RDEPEND="
	chromeos-base/libbrillo[asan?,fuzzer?]
	dev-libs/protobuf:=
	dev-util/bsdiff
"

DEPEND="${RDEPEND}"

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

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/puffin_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/puffin_test"

	# Run fuzzer.
	platform_fuzzer_test "${OUT}"/puffin_fuzzer
}
