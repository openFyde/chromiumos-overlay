# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f94fa4ae6da723e39c479c9414b28f0d2e29d0c4"
CROS_WORKON_TREE=("6aefce87a7cf5e4abd0f0466c5fa211f685a1193" "4fa61f1fa958cd34d16c6035cb2e6430dd6fd7b0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	>=chromeos-base/shill-0.0.1-r2205
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
