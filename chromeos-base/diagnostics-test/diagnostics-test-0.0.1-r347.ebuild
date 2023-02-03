# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d88c9b6a6a7ead852263a6d213d4cab2a1e4eb0a"
CROS_WORKON_TREE=("5a857fb996a67f6c9781b916ba2d6076e9dcd0a6" "176aff7883e4c5082310f71551ba0049fa8bbca3" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
