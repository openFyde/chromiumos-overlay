# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="6589eccd5b550faac865c9f182f8c6b033ce0f84"
CROS_WORKON_TREE=("20fecf8e8aefa548043f2cb501f222213c15929d" "13c6a4ec079a88834780ccbd1597c8e59d479f90" "ba414ad0d84630d5bf4ac4f82bb576f80b0d5491" "5d7d09593646cbe64ca996b1239729d1543348fd" "d34c6cf15d9577557d5d5c2a27b40c3021fe6a1d" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation tpm_manager trunks .gn"

PLATFORM_SUBDIR="libhwsec"

inherit cros-workon platform

DESCRIPTION="Crypto and utility functions used in TPM related daemons."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libhwsec/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test fuzzer tpm tpm2 tpm_dynamic"

COMMON_DEPEND="
	chromeos-base/libhwsec-foundation
	chromeos-base/tpm_manager-client
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
	platform_install
}


platform_pkg_test() {
	platform test_all
}
