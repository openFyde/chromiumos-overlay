# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=6

CROS_WORKON_COMMIT="52bb12df7f36925c3913faae70581607c2f3cfc5"
CROS_WORKON_TREE=("8e516de8961c22228293b5d8bc6c23905f116abd" "936f5a8d578baa82d0a53802889b3103fc577f9f" "7751f7bb5459651b1c827e9e035faa33b278727c" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
KEYWORDS="*"
IUSE="tpm tpm2"
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

DEPEND="
	${RDEPEND}
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
