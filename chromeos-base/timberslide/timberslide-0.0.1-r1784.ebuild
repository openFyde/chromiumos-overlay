# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="01611cc312c9b3acec36920032731ee8be032d07"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "eb510d666a66e6125e281499b649651b849a25f7" "6063e9ca8abd6253e6936ab14eedbeb4a522b2fd" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
