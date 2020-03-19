#!/bin/sh
# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# This script is run in the factory process, which sets serial number bits
# properly for cr50.

READ_RMA_SN_BITS="/usr/share/cros/cr50-read-rma-sn-bits.sh"
GSCTOOL="/usr/sbin/gsctool"

# The return codes for different failure reasons.
ERR_GENERAL=1
ERR_ALREADY_SET=2
ERR_ALREADY_SET_DIFFERENT=3
ERR_FORBIDDEN_TO_SET=4

die_as() {
  local exit_value="$1"
  shift
  echo "ERROR: $*"
  exit "${exit_value}"
}

die() {
  die_as "${ERR_GENERAL}" "$*"
}

cr50_compute_updater_sn_bits() {
  local serial_number="$1"

  # SN Bits are defined as the first 96 bits of the SHA256 of the serial number.
  # They are passed to the updater as a string of 24 hex characters.


  printf '%s' "${serial_number}" |
    openssl dgst -sha256 |
    sed -e 's/.*=[^0-9a-f]*//I' -e 's/\(.\{24\}\).*/\1/'
}

is_board_id_set() {
  local output
  if ! output="$("${GSCTOOL}" -a -i)"; then
    die "Failed to execute ${GSCTOOL} -a -i"
  fi

  # Parse the output. E.g., 5a5a4146:a5a5beb9:0000ff00
  output="${output##* }"

  [ "${output%:*}" != "ffffffff:ffffffff" ]
}

cr50_check_sn_bits() {
  local sn_bits="$1"

  local output
  if ! output="$("${READ_RMA_SN_BITS}")"; then
    die "Failed to read RMA+SN Bits."
  fi

  # The output has version and reserved bytes followed by a colon (':'), then
  # RMA flags followed by a colon and SN Bits.

  local device_version_and_rma_bytes="${output%:*}"
  local device_rma_flags="${device_version_and_rma_bytes#*:}"
  if [ "${device_rma_flags}" != ff ]; then
    die "This device has been RMAed, SN Bits cannot be set."
  fi

  local device_sn_bits="${output##*:}"
  if [ "${device_sn_bits}" = "ffffffffffffffffffffffff" ]; then
    # SN Bits are cleared, it's ok to go ahead and set them.
    return 0
  fi

  # Check if the SN Bits have been set differently.
  if [ "${device_sn_bits}" != "${sn_bits}" ]; then
    die_as "${ERR_ALREADY_SET_DIFFERENT}" "SN Bits have been set differently" \
      " (${device_sn_bits} vs ${sn_bits})."
  fi

  die_as "${ERR_ALREADY_SET}" "SN Bits have already been set."
}

cr50_set_sn_bits() {
  local sn_bits="$1"

  "${GSCTOOL}" -a -S "${sn_bits}" 2>&1
  local status=$?
  if [ "${status}" -ne 0 ]; then
    local warning
    if [ "${status}" -gt 2 ] && is_board_id_set; then
      warning=" (BoardID is set)"
    fi
    die "Failed to set SN Bits to ${sn_bits}${warning}."
  fi
}

main() {
  local serial_number
  serial_number="$(vpd_get_value serial_number 2>/dev/null)"

  if [ -z "${serial_number}" ]; then
      die "No serial number assigned yet."
  fi

  # Compute desired SN Bits, check that they can be set, and set them.

  local sn_bits
  sn_bits="$(cr50_compute_updater_sn_bits "${serial_number}")"

  cr50_check_sn_bits "${sn_bits}"
  cr50_set_sn_bits "${sn_bits}"

  echo "Successfully updated SN Bits for ${serial_number}."
}

main

