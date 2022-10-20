# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="7ee04bf9a0dda4d0cbc19b0a987ea068f3f83161"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "662e26e4ddaacdac38a8d1e2106796019dcc2b9d" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
