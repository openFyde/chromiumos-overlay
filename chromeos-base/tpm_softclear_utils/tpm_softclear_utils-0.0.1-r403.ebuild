# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="663ef988aacc4b889f99eb482addeee88619e5ee"
CROS_WORKON_TREE=("8862066a1f139e245f2b384a6818b5365f0790f3" "26f5029cdd5b8362ef6be35964b3ceb2f38bc13a" "45911603f442d596fa5d6a1c9512ec4b234a7709" "65316271af9e4b3e27ee41456d265d43b8b1623d" "54a82795ad8487a5855a632e5cd94d3d38236927" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
