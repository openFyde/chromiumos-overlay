# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="874c2a7bd09b0c6b0d944efa2b859ae51da414c3"
CROS_WORKON_TREE=("ba51cdbc1f93611f21a434aa8577a98ed1e9d5f8" "ea8176237ca94f102e81c98c7c2de00416c2c643" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/sensor_service .gn"

PLATFORM_SUBDIR="arc/vm/sensor_service"

inherit cros-workon platform

DESCRIPTION="ARC sensor service."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/sensor_service"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
"

DEPEND="
	${RDEPEND}
"

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
