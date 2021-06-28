# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Google3 document scanning library."

IUSE="march_goldmont march_armv8 ondevice_document_scanner"

SRC_URI="gs://chromeos-localmirror/distfiles/chromeos-document-scanning-lib-${PV}.tar.bz2"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

S="${WORKDIR}"

src_install() {
	insinto /usr/include/chromeos/libdocumentscanner/
	doins document_scanner.h

	if ! use ondevice_document_scanner; then
		return
	fi

	local document_scanning_lib_path="/opt/google/chrome/ml_models/document_scanning/"

	insinto "${document_scanning_lib_path}"
	# Specified architecture use flag check should be put before amd64, arm, and
	# arm64.
	insopts -m0755
	if use march_goldmont; then
		newins "x86_64-goldmont/libdocumentscanner.so" "libdocumentscanner.so"
	elif use march_armv8; then
		newins "armv7-armv8-a+crc/libdocumentscanner.so" "libdocumentscanner.so"
	elif use amd64; then
		newins "x86_64/libdocumentscanner.so" "libdocumentscanner.so"
	elif use arm; then
		newins "armv7/libdocumentscanner.so" "libdocumentscanner.so"
	elif use arm64; then
		newins "arm/libdocumentscanner.so" "libdocumentscanner.so"
	fi
	insopts -m0644
}
