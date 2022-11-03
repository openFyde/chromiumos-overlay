# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="666db4fd2dedc2bf2e70cb0f9bb93e26715489d6"
CROS_WORKON_TREE=("949c73de3faed1daba26b0dcf53a03f571b02837" "2b3f582de0a700cb2dea7f42fb43040683af0a0c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
