# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="056e8c280d58c0d8e837bf7bdfe3ddbb3d3d49f3"
CROS_WORKON_TREE="f6f3e61a37b6d4dcb7b85f70fba3f12d4ca5267c"
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
