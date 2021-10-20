# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="012ad290702143b0513b81499071056a3870e706"
CROS_WORKON_TREE=("0eb41e5da113495ed84a62fb776c5190764cc83d" "b5b115b2b168baedba931733a4baaa59c593baf3" "f864cc78ddb7b33f44b3ed6a47c0df1c53e2d07a" "d6e7e374c60befa63f5babc864b4a794198c233a" "1e9ca239fab09ba22b58e4a22d63e2ede865b159" "d8da1275feb26afab354f35df7316b3840f8330b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="attestation common-mk hwsec-test-utils libhwsec libhwsec-foundation trunks .gn"

PLATFORM_SUBDIR="hwsec-test-utils"

inherit cros-workon platform

DESCRIPTION="Hwsec-related test-only features. This package resides in test images only."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/hwsec-test-utils/"

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

	# Installs attestation-injected-keys
	dobin "${OUT}/attestation-injected-keys"

	# Installs hwsec-test-va
	dobin "${OUT}/hwsec-test-va"

	# Install fake pca agent
	dobin "${OUT}"/fake_pca_agentd

}

platform_pkg_test() {
	platform_test "run" "${OUT}/hwsec-test-utils_testrunner"
}
