# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="a830012fbd3cb6812b3d01c5846d1ab23618c02d"
CROS_WORKON_TREE=("79fac61039fd2754d03bcc2c4f0caad6c3f4ed72" "110c8104767d0b76d7aa6171b8e6c58297e9563e" "0cae368ccd314c74ac8823e622246f5900e9f923" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
