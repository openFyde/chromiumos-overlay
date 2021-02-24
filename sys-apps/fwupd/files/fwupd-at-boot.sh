#!/bin/bash
# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# We block the UI at splash screen to check for available firmware
# updates and apply them. This script is called by `pre-ui` upstart job.

LOGGER_TAG="fwupd-at-boot"

main() {
  local ret=0

  if [ "$#" -ne 0 ]; then
	logger -t "${LOGGER_TAG}" "Too many arguments."
	return 1
  fi

  local pending
  pending="$(find /var/lib/fwupd/pending -type f -size -100c 2>/dev/null)"
  if [ -z "${pending[*]}" ]; then
	return "${ret}"
  fi

  # Background process that shows boot alert.
  chromeos-boot-alert update_fwupd_firmware &
  local bg_pid=$!

  # Give it a second for USB enumeration to detect devices.
  sleep 1

  local i
  for i in "${pending[@]}"; do
    # Trigger fwupdtool-update job, which blocks until the job completes.
    /sbin/initctl emit fwupdtool-update GUID="${i##*/}" \
      PLUGIN="$(cat "${i}")" AT_BOOT="true" || ret=1
    rm "${i}"
  done

  return "${ret}"
}

main "$@"
