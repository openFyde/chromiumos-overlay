# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="db60de95925b9cfa3f5f8ff83232de073abf50ed"
CROS_WORKON_TREE=("45d2d3f6225f2e66796a2a4a833460156c777c42" "8fc14973373f54152f16326c133b3bdf540e11f7" "e769b4d25e093b59a0fc585a15f2767f8c90f0fc" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
