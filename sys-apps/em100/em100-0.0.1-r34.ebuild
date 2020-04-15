# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
CROS_WORKON_COMMIT="ecbb6028c47522e2eda826717903ed983c33c23c"
CROS_WORKON_TREE="4f95e37325d8a87175e457209d6ced644d8169e9"
CROS_WORKON_PROJECT="chromiumos/third_party/em100"

inherit cros-workon toolchain-funcs

DESCRIPTION="A simple utility to control a Dediprog EM100pro from Linux"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"

src_compile() {
	tc-export CC PKG_CONFIG

	emake
}

src_install() {
	dosbin em100
}
