# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="ELAN TouchPad Firmware Updater (HID-Interface) for B50"
HOMEPAGE="https://github.com/jinglewu/etphidiap/"
SRC_URI="https://github.com/jinglewu/etphidiap/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-fix-compile.patch"
)

src_configure() {
	tc-export CC
}

src_install() {
	dosbin etphid_updater
}
