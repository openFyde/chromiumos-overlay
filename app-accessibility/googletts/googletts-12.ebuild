# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3
#
# Web assembly port of the Google text-to-speech engine.

EAPI=6

DESCRIPTION="Google text-to-speech engine"
SRC_URI="gs://chromeos-localmirror/distfiles/${P}.tar.xz"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

# Files in /usr/share/chromeos-assets/speech_synthesis/ moved from
# chromeos-base/common-assets.
RDEPEND="!<chromeos-base/common-assets-0.0.2-r123"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/chromeos-assets/speech_synthesis/patts
	doins *.{css,html,js,json,wasm,xvoice}
}
