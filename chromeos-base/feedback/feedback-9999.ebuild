# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk feedback .gn"

PLATFORM_SUBDIR="feedback"

inherit cros-workon platform

DESCRIPTION="Feedback service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/feedback/"
LICENSE="BSD-Google"
KEYWORDS="~*"

RDEPEND=""
DEPEND="chromeos-base/system_api:="

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
