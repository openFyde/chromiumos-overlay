# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="6ff439321073109d6343280da70a4aae6cc51f65"
CROS_WORKON_TREE="d7c13648444d5a52954a8b9a842524ca743a92ac"
CROS_WORKON_PROJECT="chromiumos/platform/battery_updater"
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon

DESCRIPTION="Battery Firmware Updater"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

src_install() {
	insinto "/etc/init"
	doins "scripts/chromeos-battery-update.conf"
	exeinto "/opt/google/battery/scripts"
	doexe scripts/chromeos-battery-update.sh
}
