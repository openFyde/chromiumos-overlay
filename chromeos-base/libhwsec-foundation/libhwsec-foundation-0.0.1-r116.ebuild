# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="012ad290702143b0513b81499071056a3870e706"
CROS_WORKON_TREE=("b5b115b2b168baedba931733a4baaa59c593baf3" "e08a2eb734e33827dffeecf57eca046cd1091373" "d6e7e374c60befa63f5babc864b4a794198c233a" "1e9ca239fab09ba22b58e4a22d63e2ede865b159" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug/1184685): "libhwsec" is not necessary; remove it after solving
# the bug.
CROS_WORKON_SUBTREE="common-mk metrics libhwsec libhwsec-foundation .gn"

PLATFORM_SUBDIR="libhwsec-foundation"

inherit cros-workon platform

DESCRIPTION="Crypto and utility functions used in TPM related daemons."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/libhwsec-foundation/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test tpm tpm_dynamic tpm2"

RDEPEND="
	>=chromeos-base/metrics-0.0.1-r3152
	chromeos-base/system_api
	chromeos-base/tpm_manager-client
	"

src_install() {
	insinto /usr/include/libhwsec-foundation
	doins ./hwsec-foundation_export.h
	doins ./signature_traits.h
	doins ./fuzzed_trousers_utils.h

	insinto /usr/include/libhwsec-foundation/syscaller
	doins ./syscaller/syscaller.h
	doins ./syscaller/syscaller_impl.h
	doins ./syscaller/mock_syscaller.h

	insinto /usr/include/libhwsec-foundation/tpm_error
	doins ./tpm_error/tpm_error_data.h
	doins ./tpm_error/handle_auth_failure.h

	insinto /usr/include/libhwsec-foundation/utility
	doins ./utility/conversions.h
	doins ./utility/crypto.h

	insinto /usr/include/libhwsec-foundation/error
	doins ./error/error.h
	doins ./error/caller_info.h
	doins ./error/error_message.h
	doins ./error/testing_helper.h

	insinto /usr/include/libhwsec-foundation/tpm
	doins ./tpm/tpm_version.h

	dolib.so "${OUT}"/lib/libhwsec-foundation.so

	dosbin "${OUT}"/tpm_version_client

	if use tpm_dynamic; then
		dosbin tool/tpm_version

		insinto /etc/init
		doins init/no-tpm-checker.conf
	fi
}

platform_pkg_test() {
	local tests=(
		hwsec-foundation_testrunner
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
