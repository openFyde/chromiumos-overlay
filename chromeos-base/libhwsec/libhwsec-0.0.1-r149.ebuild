# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="0de749172817084d6c0867f1c9c4ce46b64c7c3d"
CROS_WORKON_TREE=("92fa6c1373050d9593236b88ef883cf2b7d0a85a" "989d840598227b15d78525d5f92c806011a9c158" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libhwsec .gn"

PLATFORM_SUBDIR="libhwsec"

inherit cros-workon platform

DESCRIPTION="Crypto and utility functions used in TPM related daemons."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/libhwsec/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test tpm2"

COMMON_DEPEND="
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
