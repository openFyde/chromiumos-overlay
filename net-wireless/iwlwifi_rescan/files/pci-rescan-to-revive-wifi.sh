#!/bin/sh

# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Workaround for b:35648315 where Cyan devices lose touch with the wifi NIC
# in the field. The workaround is to unbind the driver, rescan the PCI bus
# and bind the driver again. Logs from the field show that the device is
# possibly disappearing off the bus for a short while, and when it comes
# back, the pci config space is intact, but memory-mapped registers are
# not OK (reading all Fs).
# Rescanning the bus implies a memory window is allocated again.

TAG="pci-rescan"

###### Helpers

# $1: function that evaluates a condition to check for.
wait_for_true_or_time_out() {
  local count
  for count in $(seq 0 1 60); do
    if "$@"; then
      RESULT=true
      return 0
    fi
    sleep 1
  done
  return 1
}

wifi_nic_in_lspci() {

  # Check for the Intel wifi PCI ID
  # 8086:095a/095b = StonePeak2
  # 8086:08b1/08b2 = WilkinsPeak2
  if [ -n "$(lspci -n -d 8086:095a)" ] || \
     [ -n "$(lspci -n -d 8086:095b)" ] || \
     [ -n "$(lspci -n -d 8086:08b1)" ] || \
     [ -n "$(lspci -n -d 8086:08b2)" ]; then
    logger -t ${TAG} "Successfully found PCI wifi device in lspci"
    return 0
  else
    logger -t ${TAG} "No known PCI wifi device in lspci, retrying scan..."
    # A rescan does not delete any devices already discovered. It only checks
    # for new devices, so we are still good. A retry also covers the cases where
    # the wifi device may take some time to come back up rather than
    # immediately. Note that wait_for_true_or_time_out tries 60 times, so in
    # the worst case, we may end up rescanning all of those 60 times.
    echo 1 > /sys/bus/pci/rescan
    return 1
  fi
}

wlan0_present() {
  if [ -e "/sys/class/net/wlan0" ]; then
    logger -t ${TAG} "Successfully found /sys/class/net/wlan0"
    return 0
  else
    logger -t ${TAG} "Can't find /sys/class/net/wlan0"
    return 1
  fi
}

shill_has_wlan0() {
  local count
  count=$(dbus-send --system --print-reply --dest=org.chromium.flimflam \
          /device/wlan0 \
          org.chromium.flimflam.Device.GetProperties | grep -c wlan0)
  if [ ${count} -ge 0 ]; then
    logger -t ${TAG} "Shill brought up wlan0, interface is functional"
    return 0
  else
    logger -t ${TAG} "Shill can't bringup wlan0, interface not functional"
    return 1
  fi
}

###### main

main() {
  # Add an UMA metric that shows the state of wifi after the rescan
  # with the following enum:
  # 0 : NIC not detected in lspci
  # 1 : NIC shows in lspci but wlan0 doesnt exist / shill doesn't know.
  # 2 : NIC shows in lspci, /sys/class/net/wlan0 exists, shill doesn't know.
  # 3 : all of (2) and shill knows about wlan0 interface.
  # Note that what the users see in the UI is based on the UI asking shill
  # for wlan0 over dbus, so 3 is the only "happy" case for users here.
  local wifi_status=0
  local buf

  # Get rid of wifi module to restart cleanly.
  modprobe -r iwlmvm iwlwifi
  logger -t ${TAG} "Starting pci bus rescan"
  echo 1 > /sys/bus/pci/rescan
  # Delay b/w rescanning pci bus and wlan0 appearining is 100-300 ms. Hence
  # sleep here to make the checks below easier.
  sleep 1

  ###### Check, log and record metric.
  if wait_for_true_or_time_out wifi_nic_in_lspci; then
    wifi_status=1
    if wait_for_true_or_time_out wlan0_present; then
      wifi_status=2
      # wlan0 has reappeared, now restart wpasupplicant
      # and shill so that they know about the new interface.
      restart wpasupplicant
      restart shill
      if wait_for_true_or_time_out shill_has_wlan0; then
        wifi_status=3
      fi
    fi
  else
    logger -t ${TAG} "Wifi NIC did not show up in lspci"
    buf="$(lspci -vvv)"
    echo "${buf}" | logger -t ${TAG}
  fi

  logger -t ${TAG} "Sending metric: Platform.WiFiStatusAfterForcedPCIRescan: \
      ${wifi_status}"
  metrics_client -e Platform.WiFiStatusAfterForcedPCIRescan ${wifi_status} 3
}

main
