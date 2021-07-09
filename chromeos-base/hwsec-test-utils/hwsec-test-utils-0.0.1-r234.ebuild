# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="2d559f6bdf449baa1cff830ed9d1915cc0dcc18c"
CROS_WORKON_TREE=("a6533e625126197491a701941a4a825a2635ef7a" "791c6808b4f4f5f1c484108d66ff958d65f8f1e3" "59f1621d9b52cf5be4405387ead8ef5b38ad053c" "e3877395b1ff2330abd454020d0bdb94ababa1e3" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
