#!/bin/sh
# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# This script sets up Cr50 flash log time base, and then retrieves the Cr50
# flash log entries collected since the previous run and reports flash log
# events IDs to the UMA server.
#
# The previous run is identified by the timestamp saved in a file which
# survives reboots, updates and powerwashes.
#
# if the file does not exist, all Cr50 flash log entries are extracted and the
# timestamp of the last entry is saved.

TIMESTAMP_FILE_DIR="/mnt/stateful_partition/unencrypted/preserve"
TIMESTAMP_FILE_BASE="cr50_flog_timestamp"
TIMESTAMP_FILE="${TIMESTAMP_FILE_DIR}/${TIMESTAMP_FILE_BASE}"
TOP_PID="$$"

script_name="$(basename "$0")"

logit() {
  logger -t "${script_name}" -- "$@"
}

die() {
  local text="$*"

  logit "Fatal error: ${text}"
  exit 1
}

main() {
  local exit_code
  local epoch_secs
  local prev_stamp

  if [ ! -f "${TIMESTAMP_FILE}" ]; then
    logit "${TIMESTAMP_FILE} not found, creating"
    echo 0 > "${TIMESTAMP_FILE}" || die "failed to create ${TIMESTAMP_FILE}"
  fi


  # Set Cr50 flash logger time base.
  epoch_secs="$(date '+%s')"
  gsctool -a -T "${epoch_secs}" ||
    die "Failed to set Cr50 flash log time base to ${epoch_secs}"
  logit "Set Cr50 flash log base time to ${epoch_secs}"

  prev_stamp="$(cat "${TIMESTAMP_FILE}")"

  # Log lines returned by gsctool -L consist of the header followed by the
  # space separated bytes of the log entry . The header is two colon separated
  # fields, the first field - the entry timestamp, the second field - the log
  # event ID.
  #
  # After awk processing below just the header is printed for each line.
  gsctool -a -L "${prev_stamp}" | awk '{print $1}' | while read entry; do
    local event_id
    local new_stamp

    event_id="$(echo "${entry}" | sed 's/.*://')"
    new_stamp="$(echo "${entry}" | sed 's/:.*//')"

    metrics_client -s "Platform.Cr50.FlashLog" "0x${event_id}"
    exit_code="$?"
    if [ "${exit_code}" = 0 ]; then
      echo "${new_stamp}" > "${TIMESTAMP_FILE}"
    else
      die "failed to log event ${event_id} at timestamp ${new_stamp}"
    fi
  done
}

main "$@"
