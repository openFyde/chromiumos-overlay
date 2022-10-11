#!/bin/sh
#
# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Assumes the first 'version =' line in the Cargo.toml is the version for the
# crate.
awk '/^version = / { gsub(/"/, "", $0); print $3; exit }' \
  "$1/libchromeos-rs/src/deprecated/poll_token_derive/Cargo.toml"
