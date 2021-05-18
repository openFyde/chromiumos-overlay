# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Google3 face detection library."

IUSE="march_goldmont march_armv8"

SRC_URI="gs://chromeos-localmirror/distfiles/chromeos-facessd-lib-${PV}.tar.bz2"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

S="${WORKDIR}"

src_install() {
	# Specified architecture use flag check should be put before amd64, arm, and
	# arm64.
	if use march_goldmont; then
		dolib.so ./x86_64-goldmont/libfacessd_cros.so
	elif use march_armv8; then
		dolib.so ./armv7-armv8-a+crc/libfacessd_cros.so
	elif use amd64; then
		dolib.so ./x86_64/libfacessd_cros.so
	elif use arm; then
		dolib.so ./armv7/libfacessd_cros.so
	elif use arm64; then
		dolib.so ./arm/libfacessd_cros.so
	fi

	insinto /usr/include/cros-camera
	doins ./*.h

	# Install model file and anchor file
	insinto /opt/google/cros-camera/ml_models
	doins ./*.pb ./*.tflite
}
