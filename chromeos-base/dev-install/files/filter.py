#!/usr/bin/python
# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Filter out all the packages that are already in chromeos.
cros_pkgs = set(open('target-os.packages', 'r').readlines())
port_pkgs = set(open('portage.packages', 'r').readlines())

boot_pkgs = port_pkgs - cros_pkgs

# After bootstrapping the package will be assumed
# to be installed by emerge.
prov_pkgs = [x for x in boot_pkgs if not x.startswith('virtual/')]
f = open('chromeos-base.packages', 'a')
f.write(''.join(prov_pkgs))
f.close()
