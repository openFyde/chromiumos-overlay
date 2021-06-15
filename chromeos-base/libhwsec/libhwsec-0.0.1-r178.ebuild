# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="f34cf3a06f7b17b7829185630d886a5d9d3f0e75"
CROS_WORKON_TREE=("791c6808b4f4f5f1c484108d66ff958d65f8f1e3" "81dfbbc1756a3b4224b447e7bf10a916d97c4f66" "dab540c54cd768848b0688ad9989a314e31667f2" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation .gn"

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
"

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_install() {
	insinto /usr/include/chromeos/libhwsec
	doins ./*.h

	insinto /usr/include/chromeos/libhwsec/overalls
	doins ./overalls/overalls.h
	doins ./overalls/overalls_api.h

	if ! use tpm2; then
		insinto /usr/include/chromeos/libhwsec/test_utils/tpm1
		doins ./test_utils/tpm1/*.h
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
