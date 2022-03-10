#!/bin/sh
# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# This file defines constants for Cr50 devices. The constants are then used in
# the shared GSC scripts.

gsc_image_base_name() {
  printf "/opt/google/cr50/firmware/cr50.bin"
}

gsc_metrics_prefix() {
  printf "Platform.Cr50"
}
