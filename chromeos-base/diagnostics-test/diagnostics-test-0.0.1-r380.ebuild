# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f72112d28ece937dc179bdeaa2924228698f0557"
CROS_WORKON_TREE=("f834e7e40228b458c4100226f262117a9d85cdb3" "096f9d286a52ad5adbf8507f9b1391e020fa09fd" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
