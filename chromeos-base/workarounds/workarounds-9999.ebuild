# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit cros-workon

DESCRIPTION="Chrome OS workarounds utilities."
HOMEPAGE="http://src.chromium.org"
SRC_URI=""
LICENSE="BSD"
KEYWORDS="~x86 ~arm"
SLOT="0"
IUSE=""

src_install() {
        dobin channel_change
        dobin crosh-workarounds
        dobin mkcrosusb
}
