# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="c20ee06594b39da7d622234ecac221bab65a3d60"
CROS_WORKON_TREE=("29507d0246af814a4dbee96cbb78d2fd43dd52c9" "40fdda62758bee13a3b03c7cde0799191027a25f" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk policy_utils .gn"

PLATFORM_SUBDIR="policy_utils"

inherit cros-workon platform

DESCRIPTION="Device-policy-management library and tool for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/policy_utils/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/libbrillo:=
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/system_api
"

RDEPEND="
	${COMMON_DEPEND}
"

src_install() {
	dosbin "${OUT}/policy"
}

platform_pkg_test() {
	local tests=(
		libmgmt_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
