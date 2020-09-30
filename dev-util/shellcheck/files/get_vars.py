#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
"""Extract eclass variable names into Haskell list format."""

from __future__ import print_function

import os
import re
import sys
import textwrap

# Variables that have been seen in any eclass previously.
SEEN_VARS = set()

# Matches a line that declares a variable in an eclass.
VAR_RE = re.compile(r'@(?:ECLASS-)?VARIABLE:\s*(\w+)$')


def print_var_list(eclass, eclass_vars):
  var_list = ' '.join(['"%s",' % v for v in sorted(eclass_vars)])
  print('    -- %s\n%s' %
        (eclass,
         textwrap.fill(
             var_list, 80, initial_indent='    ', subsequent_indent='    ')))


def process_file(eclass_path):
  eclass_name = os.path.basename(eclass_path)
  with open(eclass_path, 'r') as f:
    eclass_vars = []
    for line in f:
      match = VAR_RE.search(line)
      if not match:
        continue

      var_name = match.group(1)
      if var_name in SEEN_VARS:
        continue

      SEEN_VARS.add(var_name)
      eclass_vars.append(var_name)

    if eclass_vars:
      print('')
      print_var_list(eclass_name, eclass_vars)


def main(argv):
  for path in sorted(argv, key=os.path.basename):
    if not path.endswith('.eclass'):
      continue

    process_file(path)


if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))
