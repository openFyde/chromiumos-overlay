#!/bin/sh
# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# This script is to maintain cupsd's privileged directories (/var/spool/cups
# and /var/cache/cups).

# cupsd waits for the stamp file before starting.
stamp=/run/cups/stamp
rm -f "${stamp}"
stop cupsd || :
mkdir -p /run/cups
logger -t "${UPSTART_JOB}" "Removing privileged directories"
if ! error=$(rm -rf /var/spool/cups /var/cache/cups 2>&1); then
  logger -t "${UPSTART_JOB}" "Failed to remove privileged directories." "${error}"
  exit 1
fi
touch "${stamp}"
