# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5a62edbb1e5d8eeeeb3a91fd6f8b56eb2af1876b"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "ef93e31dfcf83375952efc521bc6b74df17ffb9b" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk feedback .gn"

PLATFORM_SUBDIR="feedback"

inherit cros-workon platform

DESCRIPTION="Feedback service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/feedback/"
LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND=""
DEPEND="chromeos-base/system_api:="

platform_pkg_test() {
	platform test_all
}
