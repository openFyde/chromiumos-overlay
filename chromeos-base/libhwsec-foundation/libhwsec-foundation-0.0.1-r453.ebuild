# Copyright 2021 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="91181e7f74a369f51c79b13422c2a08b8590e6f9"
CROS_WORKON_TREE=("e44d7e66ab4ccaab888a42ade972724af9621706" "70d4a8ca946d6d0adf038d9afbdb57027e9887f7" "c054c10084a92bffb39a6eb8e53d25cf69f675f1" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk metrics libhwsec-foundation .gn"

PLATFORM_SUBDIR="libhwsec-foundation"

inherit cros-workon platform tmpfiles

DESCRIPTION="Crypto and utility functions used in TPM related daemons."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libhwsec-foundation/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="profiling test tpm tpm_dynamic tpm2"

DEPEND="
	>=chromeos-base/metrics-0.0.1-r3152
	chromeos-base/system_api
	chromeos-base/tpm_manager-client
	"

RDEPEND="${DEPEND}"

src_install() {
	platform_src_install

	# Install tmpfiles.d for creating dir for profiling data.
	if use profiling; then
		dotmpfiles profiling/tmpfiles.d/profiling.conf
	fi
}

platform_pkg_test() {
	platform test_all
}
