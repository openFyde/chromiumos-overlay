# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="dc16df242eeefc4fc76919f8a45618c1c53f3503"
CROS_WORKON_TREE=("e3b92b04b3b4a9c54c71955052636c95b5d2edcd" "ed37e7173bff216bca3cbf534098f9b34ea883a4" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
