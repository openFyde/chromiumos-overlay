# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="7232dbf71537bae6d8b1cbc0f60cece32edb31fe"
CROS_WORKON_TREE=("319f5d2a95f3619e313a2bfa37113f9c15a9e243" "d69331a889ece3a58b2af6179628702a2ee8f85d" "d3dca65ea14d72be7cfe4a01dcee20b783804e56" "04b304bfe9b1cb40709964339c46a34f69002fd7" "3c272999b00069d888ea77f89074d07ef40ef6d5" "944879c9353c2df8adb7022407a8d319671325c1" "70c12480ead5a9514abf5d847ca22f51aa3ea049" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="attestation common-mk hwsec-test-utils libhwsec libhwsec-foundation tpm_manager trunks .gn"

PLATFORM_SUBDIR="hwsec-test-utils"

inherit cros-workon platform

DESCRIPTION="Hwsec-related test-only features. This package resides in test images only."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/hwsec-test-utils/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test tpm tpm_dynamic tpm2"
REQUIRED_USE="
	tpm_dynamic? ( tpm tpm2 )
	!tpm_dynamic? ( ?? ( tpm tpm2 ) )
"

RDEPEND="
	tpm2? (
		chromeos-base/trunks:=
	)
	tpm? (
		app-crypt/trousers:=
	)
	chromeos-base/libhwsec:=
"

DEPEND="${RDEPEND}
	tpm2? (
		chromeos-base/trunks:=[test?]
	)
	chromeos-base/attestation:=
	chromeos-base/libhwsec-foundation:=
	chromeos-base/system_api:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
"

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
