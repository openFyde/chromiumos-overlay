# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
CROS_WORKON_COMMIT="f09239ce28b587c03a0f94d2bb98abc04fadfbb4"
CROS_WORKON_TREE="de88b2327932c2c5e947d469ea569ff9db216e15"
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
