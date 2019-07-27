# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=6

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk tpm_softclear_utils trunks .gn"

PLATFORM_SUBDIR="tpm_softclear_utils"

inherit cros-workon platform

DESCRIPTION="Utilities for soft-clearing TPM. This package resides in test images only."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/tpm_softclear_utils/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"
IUSE="test tpm tpm2"
REQUIRED_USE="tpm2? ( !tpm )"

RDEPEND="
	tpm2? (
		chromeos-base/trunks
	)
	!tpm2? (
		app-crypt/trousers
	)
	chromeos-base/libbrillo
	chromeos-base/libchrome
"

DEPEND="${RDEPEND}
	tpm2? (
		chromeos-base/system_api
		chromeos-base/trunks[test?]
	)
"

src_install() {
	# Installs the utilities executable.
	insinto /usr/local/bin
	doins "${OUT}/tpm_softclear"
	chmod u+x "${D}/usr/local/bin/tpm_softclear"

	# Installs header files
	insinto /usr/include/tpm_softclear_utils
	doins ./*.h
}

platform_pkg_test() {
	platform_test "run" "${OUT}/tpm_softclear_utils_testrunner"
}
