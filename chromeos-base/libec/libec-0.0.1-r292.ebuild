# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="4b5004eedb8038f8d1c27016b934d104174b0a8a"
CROS_WORKON_TREE=("c1d4f17552e0c5810f9a7b2470f180fd1be2bf4f" "684de7632fb3bf23e07149db10c51780f7a80c39" "def6081c0de022b16358c214a254066f6acd74bc" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="biod common-mk libec .gn"

PLATFORM_SUBDIR="libec"

inherit cros-workon platform

DESCRIPTION="Embedded Controller Library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libec"

LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND=""

RDEPEND="
	${COMMON_DEPEND}
	"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/chromeos-ec-headers:=
	chromeos-base/power_manager-client:=
"

platform_pkg_test() {
	platform test_all
}
