# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2
CROS_WORKON_PROJECT="chromiumos/platform/saft"

inherit cros-workon

DESCRIPTION="ChromeOS SAFT installer"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="chromeos-base/vboot_reference
        virtual/chromeos-firmware"

src_install() {
    dstdir="/usr/sbin/firmware/saft"
    dodir "${dstdir}"
    exeinto "${dstdir}"
    doexe *.{py,sh}
}
