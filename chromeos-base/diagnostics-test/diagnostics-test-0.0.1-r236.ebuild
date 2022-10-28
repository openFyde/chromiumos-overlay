# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="546eb3118e5cfb6de75e181ad2cc8833ac13f8d1"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "09fc4e275f5af8e33400816ac728e0da0c1a9ba5" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
