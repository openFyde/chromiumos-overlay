# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Google3 face detection library."

SRC_URI="
	amd64? ( gs://chromeos-localmirror/distfiles/chromeos-facessd-lib-x86_64-${PV}.tbz2 )
	arm? ( gs://chromeos-localmirror/distfiles/chromeos-facessd-lib-armv7-${PV}.tbz2 )
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
