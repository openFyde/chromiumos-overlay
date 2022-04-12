# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="b064f849311c4ac593a1917e826c6c1eafdd3822"
CROS_WORKON_TREE=("2345346c6533c29d4e3ee84bc2bf53306247256c" "880137511e9da416bf50a2bb77dde8fa35f48dee" "13c6a4ec079a88834780ccbd1597c8e59d479f90" "ba414ad0d84630d5bf4ac4f82bb576f80b0d5491" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
