# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="5a2a4ae36f1da3d1e1704b3a9b72700e120259f4"
CROS_WORKON_TREE=("62b2b95b11c909d8729ac79b3b3be886f7dcc463" "404240d78ae6865dc503e0ecef12b98f2940363c" "59f1621d9b52cf5be4405387ead8ef5b38ad053c" "687b3baf4c816a2e6e4890c1d3b72e2e18178cbd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="attestation common-mk hwsec-test-utils trunks .gn"

PLATFORM_SUBDIR="hwsec-test-utils"

inherit cros-workon platform

DESCRIPTION="Hwsec-related test-only features. This package resides in test images only."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/hwsec-test-utils/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test tpm tpm2"
REQUIRED_USE="tpm2? ( !tpm )"

RDEPEND="
	tpm2? (
		chromeos-base/trunks:=
	)
	!tpm2? (
		app-crypt/trousers:=
	)
"

DEPEND="${RDEPEND}
	tpm2? (
		chromeos-base/trunks:=[test?]
	)
	chromeos-base/attestation:=
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
