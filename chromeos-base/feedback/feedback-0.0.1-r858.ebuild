# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e25cc2157e703ccaf61105e47cfc13ef999d50b9"
CROS_WORKON_TREE=("bc5d73e40a959dd5e4fdb5a6431004733015ac5d" "fbef38de56ffa8692d4d503955b595c58c675032" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
KEYWORDS="*"

RDEPEND=""
DEPEND="chromeos-base/system_api:="

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
