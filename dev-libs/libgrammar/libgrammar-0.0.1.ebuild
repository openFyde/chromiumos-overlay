# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Google grammar check library for Chrome OS"
HOMEPAGE="https://www.chromium.org/chromium-os"

LICENSE="BSD-Google"
SLOT="0"

SRC_URI="gs://chromeos-localmirror/distfiles/libgrammar-amd64-${PV}.tar.gz"
KEYWORDS="*"

IUSE="ondevice_grammar"

S="${WORKDIR}"

src_install() {
	# Always install the header and proto files.
	insinto /usr/include/chromeos/libgrammar/
	doins grammar_interface.h
	insinto /usr/include/chromeos/libgrammar/proto/
	doins grammar_interface.proto

	if use ondevice_grammar; then
		dolib.so "libgrammar-amd64.so"
		# Install the model files.
		insinto /opt/google/chrome/ml_models/grammar/
		doins translation_model.pb translation_model.pbtxt
		doins translation_model_*.bipe
		doins -r resources
	fi
}
