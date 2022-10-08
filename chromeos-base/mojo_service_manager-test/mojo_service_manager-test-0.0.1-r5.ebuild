# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="85b14a06205ad4309c718357829421bc4706d018"
CROS_WORKON_TREE=("4b7854d72e018cacbb3455cf56f41cee31c70fc1" "0bda441f23662d12ecd17192abdb2442abe1b629" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
