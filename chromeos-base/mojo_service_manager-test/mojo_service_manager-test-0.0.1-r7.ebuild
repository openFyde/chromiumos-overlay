# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="01611cc312c9b3acec36920032731ee8be032d07"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "04e719781ceebd62f2f0c6fcc76f46a07944b9b4" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
