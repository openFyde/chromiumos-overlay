# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="AVer VC520 firmware"
VC520_FW_VER="0.0.0018.07"
SRC_URI="https://ecrm.aver.com/SupportDownload/aver-firmware-${VC520_FW_VER}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

RDEPEND="sys-apps/aver-updater"
DEPEND=""

S="${WORKDIR}"

src_install() {
	insinto /lib/firmware/aver
	doins "${VC520_FW_VER}.dat"
}
