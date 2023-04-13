# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="1884e3c82b742377769be62d58adeb080e431553"
CROS_WORKON_TREE=("9af4067326e0bd0aaade6270a9312a91ca2642ed" "70f2571af603a245fe44a571c58a0f505a2d956a" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk swap_management .gn"

PLATFORM_SUBDIR="swap_management"

inherit cros-workon platform

DESCRIPTION="ChromeOS swap management service"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/swap_management/"
LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/minijail:=
	dev-libs/protobuf:="

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:=
	sys-apps/dbus:="

platform_pkg_test() {
	platform test_all
}
