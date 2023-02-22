# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="68d2229d6af73b5a75a39bd7369fe5747bdc169a"
CROS_WORKON_TREE=("92a7718bfe5a15c594fcc6b0855e68b0981cd9a0" "de61794a3f3fd0ed61a5ec4fd1640f271f9175d7" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk diagnostics .gn"
PLATFORM_SUBDIR="diagnostics/testing"

inherit cros-workon platform

DESCRIPTION="Test utility for cros-healthd"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/diagnostics"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/diagnostics:=
"

platform_pkg_test() {
	platform test_all
}
