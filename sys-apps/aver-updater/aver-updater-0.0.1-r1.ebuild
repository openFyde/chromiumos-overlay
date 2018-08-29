# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="cf3337b0918e15755782d8f3b11691e04f1ddc40"
CROS_WORKON_TREE="2cb9c87c0fd9d91e0cc45a743ea58accb5808754"
CROS_WORKON_PROJECT="chromiumos/third_party/aver-updater"

inherit cros-workon libchrome udev user

DESCRIPTION="AVer firmware updater"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/aver-updater"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
"

src_configure() {
	cros-workon_src_configure
}

src_install() {
	dosbin aver-updater
	udev_dorules conf/99-run-aver-updater.rules
}

pkg_preinst() {
	enewuser cfm-firmware-updaters
	enewgroup cfm-firmware-updaters
}
