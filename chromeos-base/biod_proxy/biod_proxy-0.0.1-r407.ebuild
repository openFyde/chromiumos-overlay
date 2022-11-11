# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="4b5004eedb8038f8d1c27016b934d104174b0a8a"
CROS_WORKON_TREE=("684de7632fb3bf23e07149db10c51780f7a80c39" "c1d4f17552e0c5810f9a7b2470f180fd1be2bf4f" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk biod .gn"

PLATFORM_SUBDIR="biod/biod_proxy"

inherit cros-workon platform

DESCRIPTION="DBus Proxy Library for Biometrics Daemon for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/biod/README.md"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND=""

DEPEND="
	chromeos-base/libbrillo:=
	chromeos-base/system_api:=
"

platform_pkg_test() {
	platform test_all
}
