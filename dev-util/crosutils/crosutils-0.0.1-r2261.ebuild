# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

CROS_WORKON_COMMIT="5197f0873e091747d8cf9c32d3ff9662b065de03"
CROS_WORKON_TREE="a54340808b8ad6316e04d9c905a0f145b04ea832"
CROS_WORKON_PROJECT="chromiumos/platform/crosutils"
CROS_WORKON_LOCALNAME="../scripts/"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon

DESCRIPTION="Chromium OS build utilities"
HOMEPAGE="http://www.chromium.org/chromium-os"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

src_install() {
	exeinto /usr/lib/crosutils
	doexe common.sh remote_access.sh
}
