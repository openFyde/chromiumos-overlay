#!/bin/bash
# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# This script is given one argument: the base of the source directory of
# the package, and it prints a string on stdout with the numerical version
# number for said repo.

exec "$1"/repoman/setup.py --version
