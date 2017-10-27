#!/bin/sh
#
# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

set -e

# Status codes defined by tpm-firmware-updater.
EXIT_CODE_SUCCESS=0
EXIT_CODE_ERROR=1
EXIT_CODE_NO_UPDATE=3
EXIT_CODE_UPDATE_FAILED=4
EXIT_CODE_LOW_BATTERY=5
EXIT_CODE_NOT_UPDATABLE=6
EXIT_CODE_MISSING_APPROVAL=7
EXIT_CODE_SUCCESS_COLD_REBOOT=8

# Updates a value in the vpd_params string.
update_vpd_params() {
  local params="$1"
  local key="$2"
  local value="$3"
  local stripped="$(printf "${params}" | tr ',' '\n' | grep -v "^${key}:")"
  printf "${key}:${value}\n${stripped}" | tr '\n' ','
}

# Reboot and wait to guarantee that we don't proceed further until reboot
# actually happens. Show log if a param is given.
reboot_here() {
  local answer
  if [ -n "$1" ]; then
    read -p "Press L for log or [ENTER] to reboot." answer
    case ${answer} in
      [lL]*)
        less /var/log/tpm-firmware-updater.log
        ;;
    esac
  else
    read -p "Press [ENTER] to reboot."
  fi
  reboot
  sleep 1d
  exit 1
}

export FACTORY_SHIM_CONSENT=1

main() {
  if [ ! "$#" -eq "0" ]; then
    echo "This script does not take any command line arguments."
    reboot_here
  fi

  (
    set +e
    /usr/sbin/tpm-firmware-updater 2> /var/log/tpm-firmware-updater.log
    status=$?
    echo "${status}" > /run/tpm-firmware-updater.status
  )

  local status="$(cat /run/tpm-firmware-updater.status)"
  case "${status:-1}" in
    ${EXIT_CODE_SUCCESS}|${EXIT_CODE_SUCCESS_COLD_REBOOT})
      echo "TPM Firmware Update completed successfully."
      reboot_here
      ;;
    ${EXIT_CODE_NO_UPDATE})
      echo "No update needed."
      reboot_here 1
      ;;
    ${EXIT_CODE_ERROR})
      echo "Unexpected error."
      reboot_here 1
      ;;
    ${EXIT_CODE_UPDATE_FAILED})
      # Clear upgrade approval as a precautionary measure. This helps to avoid
      # boot loops in case of systematic bugs causing the firmware updater to
      # bail out before actually starting the update.
      local vpd_params="$(vpd -i RW_VPD -g "tpm_firmware_update_params")"
      vpd_params="$(update_vpd_params "${vpd_params}" 'mode' 'failed')"
      vpd -i RW_VPD -s "tpm_firmware_update_params=${vpd_params}"
      # The TPM is likely to be in an inoperational state due to the failed
      # update. If it is, we need to go through recovery anyways to retry the
      # update. Show a message to the user telling them about the failed update
      # and reboot so the firmware can determine whether recovery is necessary.
      echo "Something went wrong and the update wasn't successful."
      reboot_here 1
      ;;
    ${EXIT_CODE_LOW_BATTERY})
      echo "Battery is low. Charge battery to at least 10% and try again."
      ;;
    ${EXIT_CODE_MISSING_APPROVAL})
      echo "Missing approval."
      reboot_here 1
      ;;
    ${EXIT_CODE_NOT_UPDATABLE})
      echo "Not updatable."
      reboot_here 1
      ;;
    *)
      echo "Undefined status code. TPM Firmware Update wasn't successful."
      reboot_here 1
      ;;
  esac
  exit 0
}
main "$@"
