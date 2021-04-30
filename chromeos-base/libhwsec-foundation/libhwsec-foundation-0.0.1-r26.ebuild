# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="abb54398c5c5342887276499c277689412fa7486"
CROS_WORKON_TREE=("0c3ac991150c21db311300731f54e240235fb7ee" "bd3be98a54fed1f45262850bb9dcb118b259b872" "c200c725a537163b64b27b630cb1b67320f627a6" "40e8ca94f5f7409d451a55986817991d4f62ed80" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
