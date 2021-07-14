# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="5a2a4ae36f1da3d1e1704b3a9b72700e120259f4"
CROS_WORKON_TREE=("404240d78ae6865dc503e0ecef12b98f2940363c" "d46672fc3b800bb8eccba6af09b2be233e7e8271" "bdd0cd96fdf09a755c9eb90627b9d211a3b83e10" "687b3baf4c816a2e6e4890c1d3b72e2e18178cbd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
IUSE="test tpm2"

COMMON_DEPEND="
	chromeos-base/libhwsec-foundation
	dev-libs/openssl:0=
	!tpm2? ( app-crypt/trousers:= )
	tpm2? ( chromeos-base/trunks:= )
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

	if ! use tpm2; then
		insinto /usr/include/chromeos/libhwsec/test_utils/tpm1
		doins ./test_utils/tpm1/*.h
		insinto /usr/include/chromeos/libhwsec/error
		doins ./error/tpm1_error.h
	else
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
