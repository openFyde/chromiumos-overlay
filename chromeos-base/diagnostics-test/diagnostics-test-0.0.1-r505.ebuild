# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="53e41a6038c07b25b592a87fa1c526c263403067"
CROS_WORKON_TREE=("6350979dbc8b7aa70c83ad8a03dded778848025d" "53b0f29e4ef9a41e937a1d721612b101107f3d16" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
