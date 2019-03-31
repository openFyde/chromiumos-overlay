# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="25caa9f49585fdafc1d6c456c1ce7cfa5a545417"
CROS_WORKON_TREE=("13228e56ac75327ed92fe81d6a0ed4f5c11c2a6a" "b2a32d57df44e060b89e86748e002a506a54a972" "b7f28b7e0df31c97b1bfc43bf28b861a6e36a493" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(dverkamp): shill should be removed once https://crbug.com/809389 is fixed.
CROS_WORKON_SUBTREE="common-mk portier shill .gn"

PLATFORM_SUBDIR="portier"

inherit cros-workon platform user

DESCRIPTION="ND Proxy Service for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/portier"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo
"
DEPEND="
	${RDEPEND}
	>=chromeos-base/system_api-0.0.1-r3259
	chromeos-base/shill
"

platform_pkg_test() {
	local tests=(
		portier_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}

src_install() {
	dobin "${OUT}"/portier_cli
	dobin "${OUT}"/portierd
}
