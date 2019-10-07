# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="AVer firmware"

VC520_FW_VER="0.0.0018.20"
CAM540_FW_VER="0.0.6002.58"
CAM340PLUS_FW_VER="0.0.1000.22"

VC520_FW_NAME="aver-vc520"
CAM540_FW_NAME="aver-cam540"
CAM340PLUS_FW_NAME="aver-cam340plus"

SRC_URI="gs://chromeos-localmirror/distfiles/${VC520_FW_NAME}-${VC520_FW_VER}.tar.xz
	gs://chromeos-localmirror/distfiles/${CAM540_FW_NAME}-${CAM540_FW_VER}.tar.xz
	gs://chromeos-localmirror/distfiles/${CAM340PLUS_FW_NAME}-${CAM340PLUS_FW_VER}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

RDEPEND="sys-apps/aver-updater"
DEPEND=""

S="${WORKDIR}"

src_install() {
	insinto /lib/firmware/aver

	doins "${VC520_FW_NAME}-${VC520_FW_VER}.dat"
	dosym "${VC520_FW_NAME}-${VC520_FW_VER}.dat" \
		"/lib/firmware/aver/${VC520_FW_NAME}-latest.dat"

	doins "${CAM540_FW_NAME}-${CAM540_FW_VER}.dat"
	dosym "${CAM540_FW_NAME}-${CAM540_FW_VER}.dat" \
		"/lib/firmware/aver/${CAM540_FW_NAME}-latest.dat"

	doins "${CAM340PLUS_FW_NAME}-${CAM340PLUS_FW_VER}.dat"
	dosym "${CAM340PLUS_FW_NAME}-${CAM340PLUS_FW_VER}.dat" \
		"/lib/firmware/aver/${CAM340PLUS_FW_NAME}-latest.dat"
}
