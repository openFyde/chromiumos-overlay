# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Google handwriting recognition library for Chrome OS"
HOMEPAGE="https://www.chromium.org/chromium-os"

LICENSE="BSD-Google"
SLOT="0"

SRC_URI="gs://chromeos-localmirror/distfiles/libhandwriting-amd64-${PV}.tar.gz"

KEYWORDS="-* amd64"

S="${WORKDIR}"

src_install() {
	# Install the shared library.
	dolib.so "libhandwriting.so"
	# Install the header and proto files.
	# The default generated header of protobuf in Chrome OS is "*.pb.h",
	# not "*.proto.h".
	sed -i 's/.proto.h/.pb.h/g' interface.h || die
	insinto /usr/include/chromeos/libhandwriting/
	doins interface.h
	insinto /usr/include/chromeos/libhandwriting/proto/
	doins interface.proto
	# Install the model files.
	insinto /opt/google/chrome/ml_models/handwriting/
	doins latin_indy.compact.fst latin_indy.pb latin_indy.tflite
	doins latin_indy_conf.tflite latin_indy_seg.tflite
}
