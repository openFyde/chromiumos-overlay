#!/bin/sh
# Copyright 2016 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

awk -F',' '
  BEGIN { RS=")" }
  $0 ~ /AC_INIT.*/ {
    sub(/^[^0-9]*/, "", $2)
    sub(/[^0-9]*$/, "", $2)
    print $2
    exit
  }
' "$1/configure.ac"
