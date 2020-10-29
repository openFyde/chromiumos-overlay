# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="237ad18a293565c92acfbb1f9170bab7714eef35"
CROS_WORKON_TREE="aa5c80eca011d83e5c8532f991e61d6211be68e6"
CROS_WORKON_PROJECT="chromiumos/third_party/sis-updater"

inherit cros-workon cros-common.mk libchrome udev user

DESCRIPTION="A tool to update SiS firmware on Mimo from Chromium OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/sis-updater"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

DEPEND="chromeos-base/libbrillo:="

RDEPEND="${DEPEND}"

src_install() {
	dosbin "${OUT}/sis-updater"
	udev_dorules conf/99-sis-usb.rules
}

pkg_preinst() {
	enewuser cfm-firmware-updaters
	enewgroup cfm-firmware-updaters
}
