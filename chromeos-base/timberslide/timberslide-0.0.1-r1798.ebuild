# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="da3a7bc1d0bc06a3bfc02e7f21e3a9f5e10d58bf"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "9da4303fca3d31774ff2a0ed56ad7e4beb63abc7" "6063e9ca8abd6253e6936ab14eedbeb4a522b2fd" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(https://crbug.com/809389)
CROS_WORKON_SUBTREE="common-mk metrics timberslide .gn"

PLATFORM_SUBDIR="timberslide"

inherit cros-workon platform

DESCRIPTION="EC log concatenator for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/timberslide/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="
	>=chromeos-base/metrics-0.0.1-r3152:=
	dev-libs/re2:=
"

DEPEND="${RDEPEND}"

platform_pkg_test() {
	platform test_all
}
