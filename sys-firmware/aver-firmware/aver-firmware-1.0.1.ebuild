# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="AVer VC520 firmware"
VC520_FW_VER="0.0.0018.07"
CAM540_FW_VER="0.0.6000.03"
CAM340PLUS_FW_VER="0.0.1001.05"
VB342_FW_VER="0.0.4002.09"
SRC_URI="gs://chromeos-localmirror/distfiles/aver-firmware-${VC520_FW_VER}.tar.gz
	gs://chromeos-localmirror/distfiles/aver-firmware-${CAM540_FW_VER}.tar.gz
	gs://chromeos-localmirror/distfiles/aver-firmware-${CAM340PLUS_FW_VER}.tar.gz
	gs://chromeos-localmirror/distfiles/aver-firmware-${VB342_FW_VER}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

RDEPEND="sys-apps/aver-updater"
DEPEND=""

S="${WORKDIR}"

src_install() {
	insinto /lib/firmware/aver
	doins "${VC520_FW_VER}.dat"
	doins "${CAM540_FW_VER}.dat"
	doins "${CAM340PLUS_FW_VER}.dat"
	doins "${VB342_FW_VER}.dat"
}
