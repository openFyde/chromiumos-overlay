#!/bin/bash
# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Use this script to regenrate the artifacts needed by the test-dlc.

set -ex

TEMP="$(mktemp -d)"
DLC_ARTIFACT_DIR="$(mktemp -d)"
BOARD="/build/reef"

mkdir -p "${DLC_ARTIFACT_DIR}"/dir
truncate -s 12K "${DLC_ARTIFACT_DIR}/file1.bin"
truncate -s 24K "${DLC_ARTIFACT_DIR}/dir/file2.bin"

build_dlc --src-dir "${DLC_ARTIFACT_DIR}" --install-root-dir "${TEMP}" \
	  --sysroot "${BOARD}" --pre-allocated-blocks "3" \
	  --version "1.0.0" --id "test-dlc" --package "test-package" \
	  --name "Test DLC"

delta_generator \
    --new_partitions="${TEMP}/build/rootfs/dlc/test-dlc/test-package/dlc.img" \
    --partition_names="dlc/test-dlc/test-package" \
    --major_version=2 \
    --out_file="dlcservice_test-dlc.payload"

cp "${TEMP}/opt/google/dlc/test-dlc/test-package/table" .
cp "${TEMP}/opt/google/dlc/test-dlc/test-package/imageloader.json" .

rm -rf "${TEMP} ${DLC_ARTIFACT_DIR}"
