# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit font

DESCRIPTION="Arimo, Tinos and Cousine in 4 weights and Symbol Neu developed by Monotype Imaging for Chrom*OS"
SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

FONT_SUFFIX="ttf"
FONT_S="${S}"
FONTDIR="/usr/share/fonts/croscore"

# Only installs fonts
RESTRICT="strip binchecks"

src_install() {
	# call src_install() in font.eclass.
	font_src_install
}
