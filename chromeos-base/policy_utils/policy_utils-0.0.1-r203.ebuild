# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="97ca3b91ac3374fb81407dfa6b47f6f78b2f2dbf"
CROS_WORKON_TREE=("c9472e5bf2ef861a0c3b602fb4ae3084a5d96ee8" "bf58ace8c926195d4bb88f6341df4c0acccfd003" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
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
