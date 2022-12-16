# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c1b8195705dfc548759d6d8a107b01a90cd0a17d"
CROS_WORKON_TREE=("232eeac462515f4e1460770a38b8ac52bef0adec" "65e77f88a8edf813cc2f50ab411ba4997139e844" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
