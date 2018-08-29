# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="c444a9c3c2eb11ed9a143dea81f30c52bc8a0b6b"
CROS_WORKON_TREE=("0a0fbef74ac40dc525a95f9339687c591f6a8534" "4a6d0ac0436f6e0e3e9c678d5cf55a13d2c099e2" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/removable-media .gn"

inherit cros-workon

DESCRIPTION="Container to run Android's removable-media daemon."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/removable-media"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="chromeos-base/mount-passthrough
	!<chromeos-base/chromeos-cheets-scripts-0.0.2-r470
"

src_install() {
	insinto /etc/init
	doins arc/removable-media/arc-removable-media.conf
}
