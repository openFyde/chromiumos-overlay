# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Google handwriting recognition library for Chrome OS"
HOMEPAGE="https://www.chromium.org/chromium-os"

LICENSE="BSD-Google"
SLOT="0"

SRC_URI="gs://chromeos-localmirror/distfiles/libhandwriting-${PV}.tar.gz"

KEYWORDS="*"

IUSE="ondevice_handwriting"

S="${WORKDIR}"

src_install() {
	# Always install the header and proto files.
	# The default generated header of protobuf in Chrome OS is "*.pb.h",
	# not "*.proto.h".
	sed -i 's/.proto.h/.pb.h/g' interface.h || die
	insinto /usr/include/chromeos/libhandwriting/
	doins interface.h
	insinto /usr/include/chromeos/libhandwriting/proto/
	doins interface.proto
	sed -i 's!chrome/knowledge/handwriting/!!g' validate.proto || die
	doins validate.proto

	if use ondevice_handwriting; then
		# Install the shared library.
		mv "libhandwriting-${ARCH}.so" "libhandwriting.so" || die
		dolib.so "libhandwriting.so"
		# Install the model files.
		insinto /opt/google/chrome/ml_models/handwriting/
		doins latin_indy.compact.fst latin_indy.pb latin_indy.tflite
		doins latin_indy_conf.tflite latin_indy_seg.tflite
		# Install the testing data.
		insinto /build/share/libhandwriting/
		doins correct_labeled_requests.pb
	fi
}
