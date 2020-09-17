# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="63b51b8b9202b3963c87df283f49d53cf961ba98"
CROS_WORKON_TREE=("3ac5056e8f73cbb04a3434397e3968f521269017" "825512278f3738ba8ac7c5f167aacd4677cfebf7" "b72ac166f659edb21f533fd55c0f7a885a85fd5e" "b93f34429b542ceec7e86143a0ddd6cea2fde7ad" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	insinto /etc/init
	doins fake_pca_agent/fake_pca_agentd.conf
	dobin "${OUT}"/fake_pca_agentd

	# Install performance test
	insinto /etc/init
	doins performance_test/cryptohome-dbus-perf.conf

}

platform_pkg_test() {
	platform_test "run" "${OUT}/hwsec-test-utils_testrunner"
}
