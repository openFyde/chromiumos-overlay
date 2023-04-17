# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="8753db580474608c9a317d2089ef38658e0ee7f3"
CROS_WORKON_TREE=("6350979dbc8b7aa70c83ad8a03dded778848025d" "a2002e5b021a481c966a494642397c400fe65c93" "693c6f3e89efd699238a8e9462136f6f9806a021" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk metrics mist .gn"

PLATFORM_SUBDIR="mist"

inherit cros-workon platform udev

DESCRIPTION="Chromium OS Modem Interface Switching Tool"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/mist/"

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
	platform test_all
}

src_install() {
	platform_src_install

	udev_dorules 51-mist.rules
}
