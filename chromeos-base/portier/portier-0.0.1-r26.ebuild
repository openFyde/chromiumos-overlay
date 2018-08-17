# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="e7f6d2aa84b3970baaf590cc4d7f56390d72be58"
CROS_WORKON_TREE=("0ffc67db3979effc8c3e1dc09a1b45719ea6814c" "c34049f8b3104637f2307c87e78dfc3eb9196b7f")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk portier"

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
