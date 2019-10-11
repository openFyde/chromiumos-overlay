#!/bin/sh

# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# Wrapper script that runs the program name, as found on ${PATH}. Used because
# hostap hwsim tests want to find these tools at an absolute path (in their
# source tree), but we want to find them at /usr/{s,}bin or /usr/local/{s,}bin
# paths, based on whether we have them in the main rootfs (base image package)
# or stateful overlay (dev/test image package).

"$(basename "$0")" "$@"
