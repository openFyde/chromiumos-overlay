# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="f06874f795ca8cbdd46073331964f11c9a5c86d5"
CROS_WORKON_TREE=("8862066a1f139e245f2b384a6818b5365f0790f3" "26f5029cdd5b8362ef6be35964b3ceb2f38bc13a" "30cd55a3a55c284f9f2318e3195f4619717a3b0c" "adc523747d8c9c57161660eeea85ddf251b41692" "54a82795ad8487a5855a632e5cd94d3d38236927" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	tpm2? ( chromeos-base/trunks:=[test?] )
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
