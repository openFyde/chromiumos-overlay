# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b7bac45a1bcba9c1d3a518248453558ec39aca07"
CROS_WORKON_TREE=("d12eaa6a060046041408b6cf0c2444c7da2bce2b" "13ccafbf14b7eede992ea804a1ea84983a68f486" "7f496168bcd30526ff9d96c34c665b62d825d39f" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
