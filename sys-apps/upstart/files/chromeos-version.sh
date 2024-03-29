#!/bin/bash
# Copyright 2020 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# This script is given one argument: the base of the source directory of
# the package, and it prints a string on stdout with the numerical version
# number for said repo.

awk '$1 ~ /^AC_INIT/ {print $2}' "$1/configure.ac" | grep -o '[0-9.]*'
