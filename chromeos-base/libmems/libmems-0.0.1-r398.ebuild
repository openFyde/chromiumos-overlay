# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a5f4e8db20698d96720098e9818ea17f05fb9417"
CROS_WORKON_TREE=("6350979dbc8b7aa70c83ad8a03dded778848025d" "7311c12446fcf9ac0faaa93a11d6cf0f33a2c95f" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libmems .gn"

PLATFORM_SUBDIR="libmems"

inherit cros-workon platform

DESCRIPTION="MEMS support library for Chromium OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libmems"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	net-libs/libiio:="
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:="

platform_pkg_test() {
	platform test_all
}
