#!/bin/bash
# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Use this script to regenerate the artifacts needed by the test-dlc.

if [ -z "${BOARD}" ]; then
  echo "BOARD variable is unset." && exit 1
else
  echo "using BOARD='${BOARD}'"
fi

set -ex

TEMP="$(mktemp -d)"
BUILD_BOARD="/build/${BOARD}"
DLC_IMAGE_DIR="build/rootfs/dlc"
DLC_PACKAGE="test-package"
PAYLOAD="dlcservice_test-dlc.payload"
LSB_RELEASE="etc/lsb-release"
UPDATE_ENGINE_CONF="etc/update_engine.conf"

for N in {1..2}; do
  DLC_ID="test${N}-dlc"
  DLC_PATH="${DLC_ID}/${DLC_PACKAGE}"
  DLC_FILES_DIR="${TEMP}/${DLC_IMAGE_DIR}/${DLC_ID}/${DLC_PACKAGE}/root"

  mkdir -p "${DLC_FILES_DIR}"/dir "./${DLC_PATH}" "${TEMP}"/etc
  truncate -s 12K "${DLC_FILES_DIR}/file1.bin"
  truncate -s 24K "${DLC_FILES_DIR}/dir/file2.bin"

  build_dlc  --install-root-dir "${TEMP}" --pre-allocated-blocks "10" \
      --version "1.0.0" --id "${DLC_ID}" --package "${DLC_PACKAGE}" \
      --name "Test${N} DLC" --build-package

  cp "${BUILD_BOARD}/${LSB_RELEASE}" "${TEMP}"/etc/
  cp "${BUILD_BOARD}/${UPDATE_ENGINE_CONF}" "${TEMP}"/etc/

  build_dlc --sysroot "${TEMP}" --rootfs "${TEMP}"

  cp "${TEMP}/opt/google/dlc/${DLC_PATH}/table" "${DLC_PATH}/."
  cp "${TEMP}/opt/google/dlc/${DLC_PATH}/imageloader.json" "${DLC_PATH}/."

  cros_generate_update_payload \
      --image "${TEMP}/build/rootfs/dlc/${DLC_PATH}/dlc.img" \
      --output "${TEMP}/${PAYLOAD}"

  # Remove the AppID because it is static and nebraska won't be able to get it
  # when different boards pass different APP IDs.
  FIND_BEGIN="{\"appid\": \""
  FIND_END="_test"
  sed -i "s/${FIND_BEGIN}.*${FIND_END}/${FIND_BEGIN}${FIND_END}/" \
   "${TEMP}/${PAYLOAD}.json"

  cp "${TEMP}/${PAYLOAD}" "${DLC_PATH}/."
  cp "${TEMP}/${PAYLOAD}.json" "${DLC_PATH}/."

  sudo rm -rf "${TEMP}"
done
