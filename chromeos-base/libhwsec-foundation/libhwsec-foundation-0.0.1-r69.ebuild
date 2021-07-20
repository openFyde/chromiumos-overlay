# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="527d113fe0909295e351ac121aeb973761264b59"
CROS_WORKON_TREE=("cc8ae75ea68e5c37c867b396c0540c8a109ed460" "c6491a3e3692d915bc2409534fa3cdef384c7795" "a5b3f3f13173ad5a1e82a4746f668f86607e7158" "3eabccd3fdf8a3ab3c8d22fecb803c49f4eaa239" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
