#!/bin/bash
# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Use this script to regenrate the artifacts needed by the test-dlc.

if [ -z "$BOARD" ]; then
  echo "BOARD variable is unset." && exit 1
else
  echo "using BOARD='$BOARD'"
fi

set -ex

TEMP="$(mktemp -d)"
DLC_ARTIFACT_DIR="$(mktemp -d)"
BUILD_BOARD="/build/$BOARD"
DLC_PACKAGE="test-package"
PAYLOAD="dlcservice_test-dlc.payload"

for N in {1..2}; do
	DLC_ID="test${N}-dlc"
	DLC_PATH="${DLC_ID}/${DLC_PACKAGE}"

	mkdir -p "${DLC_ARTIFACT_DIR}"/dir "./${DLC_PATH}"
	truncate -s 12K "${DLC_ARTIFACT_DIR}/file1.bin"
	truncate -s 24K "${DLC_ARTIFACT_DIR}/dir/file2.bin"

	build_dlc --src-dir "${DLC_ARTIFACT_DIR}" --install-root-dir "${TEMP}" \
		  --sysroot "${BUILD_BOARD}" --pre-allocated-blocks "10" \
		  --version "1.0.0" --id "${DLC_ID}" --package "${DLC_PACKAGE}" \
		  --name "Test${N} DLC"

	cp "${TEMP}/opt/google/dlc/${DLC_PATH}/table" "${DLC_PATH}/."
	cp "${TEMP}/opt/google/dlc/${DLC_PATH}/imageloader.json" "${DLC_PATH}/."

	cros_generate_update_payload \
	    --image "${TEMP}/build/rootfs/dlc/${DLC_PATH}/dlc.img" \
	    --output "${TEMP}/${PAYLOAD}"

	cp "${TEMP}/${PAYLOAD}" "${DLC_PATH}/."
	cp "${TEMP}/${PAYLOAD}.json" "${DLC_PATH}/."

	rm -rf "${TEMP} ${DLC_ARTIFACT_DIR}"
done
