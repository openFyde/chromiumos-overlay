# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
CROS_WORKON_COMMIT="dfd556ca4a9f8669a5b8ded5b6f0dd46836ee598"
CROS_WORKON_TREE="778623e4c83600cadcbb5c1b9f091991087ac7e9"
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
