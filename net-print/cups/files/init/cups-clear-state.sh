#!/bin/sh
# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# This script is to maintain cupsd's privileged directories (/var/spool/cups
# and /var/cache/cups).

stamp=/run/cups/.stamp
lock=/run/cups/.lock

mkdir -p /run/cups
(
  # This script is executed from cups-clear-state.conf and cupsd.conf.
  # Take the lock to avoid race condition.
  if ! flock -n 9; then
    exit 1
  fi

  # If the privileged directories are already cleaned up, do nothing.
  # This is to keep, e.g., the printer configuration during the session,
  # regardless of restarting cupsd.
  if [ -f "${stamp}" ]; then
    exit 0
  fi

  logger -t "${UPSTART_JOB}" "Removing privileged directories"
  error=$(rm -rf /var/spool/cups /var/cache/cups 2>&1)
  if [ "$?" -ne 0 ]; then
    logger -t "${UPSTART_JOB}" \
      "Failed to remove privileged directories." "${error}"
    exit 1
  fi
  touch "${stamp}"
) 9>"${lock}"
