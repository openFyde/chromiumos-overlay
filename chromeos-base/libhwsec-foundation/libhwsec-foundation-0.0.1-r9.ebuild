# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="32aed191322459e4d2cc0d0effc049dcdccc5799"
CROS_WORKON_TREE=("ae528dee9890ab7346a1fee2e50877007ea3e1c0" "e7637d1585735ae6b0ce3db9554f51ca6475a9ff" "c200c725a537163b64b27b630cb1b67320f627a6" "8fb703fc237db291e7f4efd77bebd7584c4a1c3c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	"

src_install() {
	insinto /usr/include/libhwsec-foundation
	doins ./hwsec-foundation_export.h

	insinto /usr/include/libhwsec-foundation/tpm_error
	doins ./tpm_error/tpm_error_data.h
	doins ./tpm_error/handle_auth_failure.h

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
