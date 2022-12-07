# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="b2dc6afece198cb219b1e3f4af92f86d6f40ce4e"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "478fda65401c49d9a8814ddd694a79ed5e1ba4f4" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk mojo_service_manager .gn"
PLATFORM_SUBDIR="mojo_service_manager/testing"

inherit cros-workon platform

DESCRIPTION="Test utility for mojo service manager"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/mojo_service_manager/README.md"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/mojo_service_manager:=
"

platform_pkg_test() {
	platform test_all
}
