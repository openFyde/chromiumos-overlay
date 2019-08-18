# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="88b389d97f389754640e3b2ee9e4b6f8e67f73e6"
CROS_WORKON_TREE="52e80238d93411f080d9e48dc73aa939138606fe"
CROS_WORKON_PROJECT="chromiumos/third_party/sis-updater"

inherit cros-workon libchrome udev user

DESCRIPTION="A tool to update SiS firmware on Mimo from Chromium OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/sis-updater"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

DEPEND="chromeos-base/libbrillo"

RDEPEND="${DEPEND}"

src_configure() {
	cros-workon_src_configure
}

src_install() {
	dosbin sis-updater
	udev_dorules conf/99-sis-usb.rules
}

pkg_preinst() {
	enewuser cfm-firmware-updaters
	enewgroup cfm-firmware-updaters
}
