# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2881193f768ced0e3dcd0d3f33e8601c091cd2a6"
CROS_WORKON_TREE=("6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "ed35276fd280df84450dfdb02cd6d978a9a823f3" "992aac33ad7ccb0076c40c778ea76970032c78a7" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk diagnostics/cros_minidiag metrics .gn"

PLATFORM_SUBDIR="diagnostics/cros_minidiag"

inherit cros-workon platform

DESCRIPTION="User space utilities related to MiniDiag"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/diagnostics/cros_minidiag"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
	>=chromeos-base/metrics-0.0.1-r3152:=
"

RDEPEND="
	sys-apps/coreboot-utils:=
"

platform_pkg_test() {
	platform test_all
}
