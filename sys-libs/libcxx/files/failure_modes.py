# -*- coding: utf-8 -*-
# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Failure mode constants avaiable to the patch manager."""

from __future__ import print_function

FAIL = 'fail'
CONTINUE = 'continue'
DISABLE_PATCHES = 'disable_patches'
BISECT_PATCHES = 'bisect_patches'
REMOVE_PATCHES = 'remove_patches'
