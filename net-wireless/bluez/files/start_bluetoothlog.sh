#!/bin/sh
# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Limit to 5MB of log.
log_size_limit=5000000

exec /sbin/minijail0 -u bluetooth -g bluetooth -Nniplrvdt --uts -c2000 \
  --profile=minimalistic-mountns \
  -k tmpfs,/var,tmpfs,0xe -b /var/log/bluetooth,,1 \
  -- /usr/bin/btmon -Sc0 -w /var/log/bluetooth/log.bz2 -l ${log_size_limit}
