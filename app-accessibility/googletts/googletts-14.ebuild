# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3
#
# Web port of the Google text-to-speech engine.

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
	local tts_path=/usr/share/chromeos-assets/speech_synthesis
	mkdir -p patts
	cp *.{css,html,js,json,png,svg,zvoice} patts/
	if use amd64 ; then
		cp libchrometts_x86_64.so patts/libchrometts.so
	elif use arm ; then
		cp libchrometts_armv7.so patts/libchrometts.so
	fi

	chmod -R 755 patts

	# Create and install a squashfs file.
	mksquashfs ${WORKDIR}/patts ${WORKDIR}/patts.squash
	keepdir "${tts_path}"/patts
	insinto /usr/share/chromeos-assets/speech_synthesis
	doins patts.squash
		insinto /etc/init
	doins googletts-start.conf
	doins googletts-stop.conf
}
