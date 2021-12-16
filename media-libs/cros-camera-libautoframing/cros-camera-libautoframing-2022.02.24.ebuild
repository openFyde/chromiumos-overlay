# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Google3 auto-framing libraries for Chrome OS."
# PV 2022.02.24: built at cl/430470469.
SRC_URI="gs://chromeos-localmirror/distfiles/chromeos-camera-libautoframing-${PV}.tbz2"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64"

S="${WORKDIR}"

src_install() {
	dolib.so ./*.so

	insinto /usr/include/cros-camera
	doins ./*.h
}
