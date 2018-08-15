# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="ELAN TouchPad Firmware Updater (HID-Interface) for B50"
GIT_TAG="v${PV}"
HOMEPAGE="https://github.com/jinglewu/etphidiap/"
MY_P="etphidiap-${PV}"
SRC_URI="https://github.com/jinglewu/etphidiap/archive/${GIT_TAG}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}/etphid_updater"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

src_configure() {
	tc-export CC
}

src_install() {
	dosbin etphid_updater
}
