# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="33b32a5d3992fe35547fdb9539d5b7632405ba71"
CROS_WORKON_TREE=("9b35e7ff9450a4dff521fa942c6d28121862845c" "720cf19b24f85b5cb772bba081aeb033fd4318b4" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="cfm-device-updater common-mk .gn"

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
