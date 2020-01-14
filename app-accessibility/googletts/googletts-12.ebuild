# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3
#
# Web assembly port of the Google text-to-speech engine.

EAPI=6

DESCRIPTION="Google text-to-speech engine"
SRC_URI="gs://chromeos-localmirror/distfiles/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

S="${WORKDIR}"

src_install() {
	insinto /usr/share/chromeos-assets/speech_synthesis/patts
	doins *.{css,html,js,json,wasm,xvoice}
}
