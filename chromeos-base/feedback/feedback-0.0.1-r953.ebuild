# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f76957fa469f8af582649807981fb592f0ba1d10"
CROS_WORKON_TREE=("db382a13f6e22c79a09ffb69ca5a504dcf6c9bd5" "5395cfe3ef077195924f7da08cada1ec5b1ded6d" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
