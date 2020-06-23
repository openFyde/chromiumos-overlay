# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c142078820d0707858873cedb290a78d36f531af"
CROS_WORKON_TREE=("eec5ce9cfadd268344b02efdbec7465fbc391a9e" "7b271150a571aef662c99ebc6d241d9cad66d766" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk shill/cli .gn"

PLATFORM_SUBDIR="shill/cli"

inherit cros-workon platform

DESCRIPTION="Shill Command Line Interface"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/shill/cli"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/shill
"

DEPEND="
	chromeos-base/shill-client:=
	chromeos-base/system_api:=
"

src_install() {
	dobin "${OUT}"/shillcli
}

platform_pkg_test() {
	platform_test "run" "${OUT}/shillcli_test"
}
