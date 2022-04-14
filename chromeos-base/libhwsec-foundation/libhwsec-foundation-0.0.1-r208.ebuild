# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="5a988f2fa65c82b807bc29df464422efd7bf7c85"
CROS_WORKON_TREE=("be0561582cec761c3be2d8ca3ac2b966901b7d58" "00259481f75253c2a5d89380dce8a452fa628140" "49d6dd8c8a59b2034582c4d00b2569722104141e" "ba414ad0d84630d5bf4ac4f82bb576f80b0d5491" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libhwsec-foundation/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test tpm tpm_dynamic tpm2"

RDEPEND="
	>=chromeos-base/metrics-0.0.1-r3152
	chromeos-base/system_api
	chromeos-base/tpm_manager-client
	"

src_install() {
	# Install header files.
	local header_dirs=(
		.
		status
		status/impl
		syscaller
		tpm_error
		utility
		error
		tpm
	)
	local d
	for d in "${header_dirs[@]}" ; do
		insinto /usr/include/libhwsec-foundation/"${d}"
		doins "${d}"/*.h
	done

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
