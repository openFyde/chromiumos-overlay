# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="66ed10a4e172bdd47b4e08f1661fe21e975c2ef9"
CROS_WORKON_TREE=("730940d1ad982b0928be2d517a8583b66235e15e" "286aebf05e21184e060f315519b20a2e0b6f96f3" "34bfe1c1a40cdabd4218082970fe89d5e52f92fe" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
