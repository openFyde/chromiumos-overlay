#!/bin/bash
# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# This script montiors dbus for suspend events and then sends a command
# to the cr50 to disable deep sleep during suspend.
# The disable deep sleep flag is transiant, so it must be resent before
# each suspend.

set -eu -o pipefail

# Remove SIGTERM trap to avoid recursion then kill process group
trap 'trap - SIGTERM && kill -- -$$' SIGTERM EXIT

script_name="$(basename "$0")"

logit() {
  logger -t "${script_name}" -- "$@"
}

# This command will disable deep sleep for just the next suspend
send_disable_deep_sleep_command_to_cr50() {
  logit "Sending disable deep sleep command to Cr50"
  if trunks_send --raw 80010000000c20000000003b >/dev/null; then
    logit "Disable sleep command sent to Cr50"
  else
    logit "Error sending disable sleep command to Cr50"
  fi
}

# Monitor for the DBus SuspendImminent signal
monitor_suspend_dbus_signal() {
  local interface='org.chromium.PowerManager'
  local signal='SuspendImminent'

  logit "Start monitoring dbus for SuspendImminent signal"
  while read -r line; do
    if [ -z "${line##*${signal}*}" ]; then
      logit "SuspendImminent signal received"
      send_disable_deep_sleep_command_to_cr50
    fi
  done < <(dbus-monitor --system --profile \
    "type='signal',interface='${interface}',member='${signal}'")
}

main() {
  monitor_suspend_dbus_signal
}

main "$@"
