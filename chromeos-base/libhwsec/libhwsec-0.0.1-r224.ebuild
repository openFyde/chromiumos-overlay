# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="abf6daab00aee9f7e2d8c155785bc9779bae8ef1"
CROS_WORKON_TREE=("97bdcefe463bb514ecfb75bb81a7b653b11a9fbd" "d0745d1765ae4f3bcb274b0b2ea28b4d78c666f8" "2141556fef8198cc45b354a458e6dbefadb07d44" "d2415395c6e1a7c646fc490d178022d3aab4decc" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation trunks .gn"

PLATFORM_SUBDIR="libhwsec"

inherit cros-workon platform

DESCRIPTION="Crypto and utility functions used in TPM related daemons."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/libhwsec/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test fuzzer tpm tpm2 tpm_dynamic"

COMMON_DEPEND="
	chromeos-base/libhwsec-foundation
	dev-libs/openssl:0=
	tpm2? ( chromeos-base/trunks:= )
	tpm? ( app-crypt/trousers:= )
	fuzzer? (
		app-crypt/trousers:=
		chromeos-base/trunks:=
	)
"

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_install() {
	insinto /usr/include/chromeos/libhwsec
	doins ./*.h

	insinto /usr/include/chromeos/libhwsec/overalls
	doins ./overalls/overalls.h
	doins ./overalls/overalls_api.h

	insinto /usr/include/chromeos/libhwsec/error
	doins ./error/tpm_error.h

	if use tpm || use fuzzer; then
		insinto /usr/include/chromeos/libhwsec/test_utils/tpm1
		doins ./test_utils/tpm1/*.h
		insinto /usr/include/chromeos/libhwsec/error
		doins ./error/tpm1_error.h
	fi
	if use tpm2 || use fuzzer; then
		insinto /usr/include/chromeos/libhwsec/error
		doins ./error/tpm2_error.h
	fi

	dolib.so "${OUT}"/lib/libhwsec.so
	dolib.a "${OUT}"/libhwsec_test.a
}


platform_pkg_test() {
	local tests=(
		hwsec_testrunner
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
