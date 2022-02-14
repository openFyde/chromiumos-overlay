# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="7919fc1be16057f4d8980cd80c6aa050c9d707d6"
CROS_WORKON_TREE=("ba51cdbc1f93611f21a434aa8577a98ed1e9d5f8" "0fe42c776d218392a636fb7810eaf289bf79ab47" "d2b226582d18266d446e1f16d3ce20df4900034d" "e5f1d0cb879d75a4dc97e80c837b39552edb422c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	platform_install
}


platform_pkg_test() {
	platform test_all
}
