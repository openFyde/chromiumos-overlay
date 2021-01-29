# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Google3 face detection library for different architectures."

IUSE="march_goldmont march_armv8"

SRC_URI="
	march_goldmont? ( gs://chromeos-localmirror/distfiles/chromeos-facessd-lib-x86_64-goldmont-${PV}.tbz2 )
	march_armv8? ( gs://chromeos-localmirror/distfiles/chromeos-facessd-lib-armv7-armv8-a+crc-${PV}.tbz2 )
	"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

S="${WORKDIR}"

src_install() {
	dolib.so ./libfacessd_cros.so

	insinto /usr/include/cros-camera
	doins ./*.h

	# Install model file and anchor file
	insinto /opt/google/cros-camera/ml_models
	doins ./*.pb ./*.tflite
}
