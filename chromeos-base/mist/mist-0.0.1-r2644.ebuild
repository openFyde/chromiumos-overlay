# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="3c36d5bbbb1f0e2064084041770c91b5c135fa83"
CROS_WORKON_TREE=("32c5802f3fce5f474cfae5f70fb058b1df68675f" "ebac15aa3d289651c8dc26f1bce58d403c89ab83" "894a706072cf8566d24b1d7c687be70a3e0f44a0")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk metrics mist"

PLATFORM_SUBDIR="mist"

inherit cros-workon platform udev

DESCRIPTION="Chromium OS Modem Interface Switching Tool"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo
	chromeos-base/metrics
	dev-libs/protobuf
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
