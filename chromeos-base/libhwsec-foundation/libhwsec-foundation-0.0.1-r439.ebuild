# Copyright 2021 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="de819d77e280814d62fc07dd9ad2fc1aa8e71a11"
CROS_WORKON_TREE=("2f5486f5d231a8a7920e3033439b1ae644f07f5d" "22d5274d1e7570d1be474dd10560ef20113f4d3c" "5d8ee0def330064cbdc03dbab3a148010a945677" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
