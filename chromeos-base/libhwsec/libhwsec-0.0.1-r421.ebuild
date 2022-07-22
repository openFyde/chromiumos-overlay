# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="61f564c63a96d64ba64f191ad08f9835a9c7426a"
CROS_WORKON_TREE=("4055d34d682d2a7ff6bc4285499301674c0779ab" "1e5958d6682a671e96d7c57a852e11ca6ad9dd93" "209bc7360763fb2435e98022e69b43ea1b3feb3a" "68532c536f0fde9d7f1caf7787121b16afd02199" "b2ae20cf5a237ca246eecb61de48d18247370fd5" "58121a138b5a642c2b87fcb3381d26f0dc4c5858" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation tpm_manager tpm2-simulator trunks .gn"

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
	dev-libs/flatbuffers
	tpm2? ( chromeos-base/trunks:=[test?] )
	tpm? ( app-crypt/trousers:= )
	fuzzer? (
		app-crypt/trousers:=
		chromeos-base/trunks:=
	)
	test? (
		chromeos-base/trunks:=[test]
		chromeos-base/tpm2-simulator:=[test]
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
