# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Copyright 2013-2014 Broadcom Corporation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="b146b5319f17fe8f21a608869fba86dccf670076"
CROS_WORKON_TREE="cc3ee50470ec05a4450e7b28291f15cc8d32e118"
CROS_WORKON_PROJECT="chromiumos/third_party/broadcom"

inherit cros-workon toolchain-funcs

DESCRIPTION="Broadcom Bluetooth Patchram Plus Firmware Download Tool"
HOMEPAGE="http://www.broadcom.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* arm"
IUSE=""

RDEPEND="net-wireless/bluez"
DEPEND="${RDEPEND}"

RESTRICT="binchecks"

src_compile() {
	tc-export AR CC
	emake -C bluetooth
}

src_install() {
    emake -C bluetooth DESTDIR="${D}" install
}
