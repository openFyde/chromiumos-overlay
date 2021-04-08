# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Google3 face detection library."

IUSE="march_goldmont march_armv8"

# Specified architecture versions should be put after amd64 and arm versions.
# For specified architectures, the ebuild will download two tarballs and unpack
# them one by one. EX: amd64 and goldmont. Therefore, specified architecture
# version will overwrite generic version.
SRC_URI="
	amd64? ( gs://chromeos-localmirror/distfiles/chromeos-facessd-lib-x86_64-${PV}.tbz2 )
	arm? ( gs://chromeos-localmirror/distfiles/chromeos-facessd-lib-armv7-${PV}.tbz2 )
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
