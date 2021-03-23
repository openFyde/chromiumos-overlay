# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="53eb7dac34bd189fa74f7e18f11a939bdfd33a27"
CROS_WORKON_TREE=("a58d199d2c4d0e5da40bb5d453f513f5e2c97ae4" "52f3994c56cd91f81f8a6ab309cb59979d2296db" "c200c725a537163b64b27b630cb1b67320f627a6" "e718030cdfb5d0b11f3effaa11633d4ec7c8d05c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
