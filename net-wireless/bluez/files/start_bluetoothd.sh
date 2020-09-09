#!/bin/sh
# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Checks for a device specific configuration and if present, starts
# bluetoothd with that config file; otherwise, starts bluetoothd with
# the legacy board-specific configuration (main.conf) if the config file
# is present.

bluetooth_dir="/etc/bluetooth"
conf_file="${bluetooth_dir}/main.conf"
config_file_param="--configfile=${conf_file}"

exec /sbin/minijail0 -u bluetooth -g bluetooth -G \
  -c 3500 -n -- \
  /usr/libexec/bluetooth/bluetoothd "${BLUETOOTH_DAEMON_OPTION}" --nodetach \
  "${config_file_param}" --experimental
