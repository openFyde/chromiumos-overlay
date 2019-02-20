# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A test Downloadable Content (DLC) module for DLC tast tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/dlcservice"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

src_unpack() {
	# Makes emerge pass.
	S="${WORKDIR}"
}

src_install() {
	# Steps to generate table and imageloader.json:
	#
	# mkdir -p ${TEMP}
	# mkdir -p ${DLC_ARTIFACT_DIR}
	# mkdir -p ${DLC_ARTIFACT_DIR}/dir
	# truncate -s 12K ${DLC_ARTIFACT_DIR}/file1.bin
	# truncate -s 24K ${DLC_ARTIFACT_DIR}/dir/file2.bin
	# chromite/scripts/build_dlc \
	#	--src-dir="${DLC_ARTIFACT_DIR}" \
	#	--install-root-dir="${TEMP}" \
	#	--fs-type="squashfs" \
	#	--pre-allocated-blocks="3" \
	#	--version="1.0.0" \
	#	--id=test-dlc \
	#	--name="test-dlc"
	# delta_generator \
	#   --new_partitions=${TEMP}/build/rootfs/dlc/test-dlc/dlc.img \
	#   --partition_names="dlc_test-dlc" \
	#   --major_version=2 \
	#   --out_file=${TEMP}/dlcservice_test-dlc.payload
	#
	# Files installed to rootfs are located at:
	#   ${TEMP}/opt/google/dlc/test-dlc/table
	#   ${TEMP}/opt/google/dlc/test-dlc/imageloader.json
	# File installed to stateful partition is located at:
	#   ${TEMP}/dlcservice_test-dlc.payload
	#
	# Notes to the payload file:
	# 1. dlcservice_test-dlc.payload is used by tast test platform.DLCService and
	#    is unlikely updated unless we see a test regression.
	# 2. When a test regression happens and we decide updating a new payload is
	#    the right cure, then platform.DLCService needs to be updated to point
	#    to the new payload location (if changed) or payload DLC ID (if changed).

	# Installs test DLC module.
	insinto /opt/google/dlc/test-dlc/
	doins ${FILESDIR}/table
	doins ${FILESDIR}/imageloader.json
	insinto /usr/local/dlc/
	doins ${FILESDIR}/dlcservice_test-dlc.payload
}
