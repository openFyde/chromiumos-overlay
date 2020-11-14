# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f4be3fbf604d2f69b13606e703741b2d0178cebd"
CROS_WORKON_TREE=("f86b3dad942180ce041d9034a4f5f9cceb8afe6b" "de088d2f305dbd542c6dc39d1cbe48efde67e3ab" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
