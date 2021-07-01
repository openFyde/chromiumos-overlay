# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="bf3d6d39923daa7144cac6fdd04976b7dc867967"
CROS_WORKON_TREE=("791c6808b4f4f5f1c484108d66ff958d65f8f1e3" "6a2c77b2943b8c30c3e6edfbbd9fafd51b89474f" "81dfbbc1756a3b4224b447e7bf10a916d97c4f66" "fe569515c8be8851c7f1eb668a169cea141ce373" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
IUSE="test tpm2"

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
