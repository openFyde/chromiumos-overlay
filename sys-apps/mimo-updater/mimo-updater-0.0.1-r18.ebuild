# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="318347ee98598f39cf67ac8af053e967ecc909a2"
CROS_WORKON_TREE="60c768301740879a62897326ce63172e91540788"
CROS_WORKON_PROJECT="chromiumos/third_party/mimo-updater"

inherit cros-workon libchrome udev user

DESCRIPTION="A tool to interact with a Mimo device from Chromium OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/mimo-updater"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	chromeos-base/libbrillo:=
	virtual/libusb:1
	virtual/libudev:0="

RDEPEND="${DEPEND}"

src_configure() {
	cros-workon_src_configure
}

src_install() {
	dosbin mimo-updater
	udev_dorules conf/90-displaylink-usb.rules
}

pkg_preinst() {
	enewuser cfm-firmware-updaters
	enewgroup cfm-firmware-updaters
}
