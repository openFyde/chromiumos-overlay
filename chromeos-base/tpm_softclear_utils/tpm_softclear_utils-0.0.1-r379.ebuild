# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="c75ade09f293cc24b511b17f16f4ee105b9e3827"
CROS_WORKON_TREE=("20fecf8e8aefa548043f2cb501f222213c15929d" "13c6a4ec079a88834780ccbd1597c8e59d479f90" "fcc0cee9081f8a03f5c6d28e9d3407db649f8385" "269119352150a99393faf5787ab5b2e2ea5ed872" "97266a4772907835fdab5d56b3ca24ed9c1c7a0e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation tpm_softclear_utils trunks .gn"

PLATFORM_SUBDIR="tpm_softclear_utils"

inherit cros-workon platform

DESCRIPTION="Utilities for soft-clearing TPM. This package resides in test images only."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/tpm_softclear_utils/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test tpm tpm_dynamic tpm2"
REQUIRED_USE="
	tpm_dynamic? ( tpm tpm2 )
	!tpm_dynamic? ( ?? ( tpm tpm2 ) )
"

RDEPEND="
	tpm2? (
		chromeos-base/trunks:=
	)
	tpm? (
		app-crypt/trousers:=
	)
	chromeos-base/libhwsec-foundation:=
"

DEPEND="${RDEPEND}
	tpm2? (
		chromeos-base/system_api:=
		chromeos-base/trunks:=[test?]
	)
"

src_install() {
	# Installs the utilities executable.
	insinto /usr/local/bin
	doins "${OUT}/tpm_softclear"
	chmod u+x "${D}/usr/local/bin/tpm_softclear"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/tpm_softclear_utils_testrunner"
}
