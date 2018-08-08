# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="fed8307ef0975df8dd3bf2d319de82e82f8b18af"
CROS_WORKON_TREE=("1bc619361d15352eb7a8216a727a1f82455b2551" "0148ea45412dc2cc546e2cdad0b406e5c2fe6683")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="cfm-device-updater common-mk"

PLATFORM_SUBDIR="cfm-device-updater"

inherit cros-workon platform libchrome user udev

DESCRIPTION="Utilities to update CFM peripherals firmwares."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
	"

DEPEND="${RDEPEND}"

pkg_preinst() {
	enewuser cfm-firmware-updaters
	enewgroup cfm-peripherals
}

src_install() {
	dosbin "${OUT}"/bizlink-updater
	udev_dorules bizlink-updater/conf/99-bizlink-usb.rules
}
