#!/bin/bash
# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# This script is given one argument: the base of the source directory of
# the package, and it prints a string on stdout with the numerical version
# number for said repo.

# This logic is similar to lib/portage/__init__.py:_LazyVersion.
VERSION=$(git --git-dir="$1/.git" describe --tags)

# Could be a tag like:
#   v2.2.12-8-g15b05e76ecb4
# or something like:
#   cros-2.2.12-r4-1-g9b31dff37f26
# or something like:
#   portage-2.3.49-11-gb99e9b40a
echo "${VERSION}" | sed -E -e 's:^(v|cros-|portage-)::' -e 's:-.*::'
