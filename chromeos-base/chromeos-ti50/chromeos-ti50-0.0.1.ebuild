# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Ebuild to support the Chrome OS TI50 device."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="cros_host"

# CR50 and TI50 share the same development tools, e.g. gsctool
RDEPEND="chromeos-base/chromeos-cr50-dev
	!cros_host? ( chromeos-base/chromeos-cr50-scripts )"

# There are two major types of images of Ti50, prod (used on most MP devices)
# and pre-pvt, used on devices still not fully released.
PROD_IMAGE="ti50.ro.0.0.26.rw.0.21.0"
PRE_PVT_IMAGE="ti50.ro.0.0.32.rw.0.22.6_FFFF_00000000_00000010"

# Ensure all images and included in the manifest.
TI50_BASE_NAMES=( "${PROD_IMAGE}" "${PRE_PVT_IMAGE}" )
MIRROR_PATH="gs://chromeos-localmirror/distfiles/"
SRC_URI="$(printf " ${MIRROR_PATH}/%s.tar.xz" "${TI50_BASE_NAMES[@]}")"

S="${WORKDIR}"

src_install() {
	# Always install both pre-pvt and MP Ti50 images, let the updater at
	# run time decide which one to use, based on the H1 Board ID flags
	# value.

	insinto /opt/google/ti50/firmware

	einfo "Will install ${PROD_IMAGE} and ${PRE_PVT_IMAGE}"

	newins "${PROD_IMAGE}"/*.bin.prod ti50.bin.prod
	newins "${PRE_PVT_IMAGE}"/*.bin.prod ti50.bin.prepvt
}
