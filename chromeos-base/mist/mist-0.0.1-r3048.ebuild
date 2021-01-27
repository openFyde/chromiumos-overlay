# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="0d5c8329c95d45206518b2b0420e9045166b19db"
CROS_WORKON_TREE=("039ed44189c17a7037215fc778a6f1fcb96b1433" "8d228c8e702aebee142bcbf0763a15786eb5b3bb" "819df31f145c1b256b5a9753dc4fc2f6681f020c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk metrics mist .gn"

PLATFORM_SUBDIR="mist"

inherit cros-workon platform udev

DESCRIPTION="Chromium OS Modem Interface Switching Tool"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/mist/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo:=[udev]
	>=chromeos-base/metrics-0.0.1-r3152
	dev-libs/protobuf:=
	net-dialup/ppp
	virtual/libusb:1
	virtual/udev
"

DEPEND="${RDEPEND}"

platform_pkg_test() {
	platform_test "run" "${OUT}/mist_testrunner"
}

src_install() {
	dobin "${OUT}"/mist

	insinto /usr/share/mist
	doins default.conf

	udev_dorules 51-mist.rules
}
