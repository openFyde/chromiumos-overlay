# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="6ff57fa38a9d7ef01f2eef93680aa515f5fdba98"
CROS_WORKON_TREE=("e838b0191f5006081b11c5d85e92adf370510ac9" "db103a9dd2c79eed8075b58d7c1c4484354a1683")
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
