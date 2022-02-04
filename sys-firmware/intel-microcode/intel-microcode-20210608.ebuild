# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the BSD license.

EAPI=7

DESCRIPTION="Intel processor microcode updates"
HOMEPAGE="https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files"

SRC_URI="https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/archive/microcode-${PV}.tar.gz"
LICENSE="intel-ucode"
KEYWORDS="-* amd64"
SLOT="0/${PVR}"

S="${WORKDIR}/Intel-Linux-Processor-Microcode-Data-Files-microcode-${PV}"

src_install() {
	insinto /lib/firmware
	doins -r "${S}/intel-ucode"
}
