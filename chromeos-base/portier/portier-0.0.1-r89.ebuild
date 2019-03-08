# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="89c295f12fd6afa21ecfae5d6e5c7ed39ec9fb72"
CROS_WORKON_TREE=("e220eed9c62e23a855f6b5ebce2310a69a9309a5" "8d75596ae83ac2826ae2ec1a7e30221dfb1824a4" "e10c6ea3d50a7273fbd0dd7ce6e71139c569f52a" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
