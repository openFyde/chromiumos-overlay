#!/bin/sh
# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

/sbin/minijail0 -u bluetooth -g bluetooth -Gn -c0 \
  --profile=minimalistic-mountns \
  -- /bin/gzip < /run/bluetooth/fifo > /var/log/bluetooth/log.gz &
exec /sbin/minijail0 -u bluetooth -g bluetooth -Nniplrvdt --uts -c2000 \
  --profile=minimalistic-mountns -k tmpfs,/run,tmpfs,0xe -b /run/bluetooth \
  -- /usr/bin/btmon -S0 -w /run/bluetooth/fifo
