#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
"""Extract eclass variable names into Haskell list format."""

from __future__ import print_function

import datetime
import os
import re
import sys
import textwrap

# Matches a line that declares a variable in an eclass.
VAR_RE = re.compile(r'@(?:ECLASS-)?VARIABLE:\s*(\w+)$')

# Matches a line that declares inheritance.
INHERIT_RE = re.compile(r'^inherit(\s+(\w|-)+)+$')

VAR_FILE_HEADER = """module ShellCheck.PortageAutoInternalVariables (
  portageAutoInternalVariables
  ) where

-- This file contains the variables generated by
-- third_party/chromiumos-overlay/dev-util/shellcheck/files/get_vars.py"""

PORTAGE_AUTO_VAR_NAME = 'portageAutoInternalVariables'


class Eclass:
  """Container for eclass information"""

  def __init__(self, name, eclass_vars, inheritances):
    self.name = name
    self.vars = eclass_vars
    self.inheritances = inheritances

  def calculate_eclass_vars(self, eclasses):
    while self.inheritances:
      name = self.inheritances.pop()
      try:
        sub_eclass = eclasses[name]
        new_vars = sub_eclass.calculate_eclass_vars(eclasses).vars
        self.vars = self.vars.union(new_vars)
      except Exception:
        pass
    return self


def print_var_list(eclass, eclass_vars):
  var_list = ' '.join(['"%s",' % v for v in sorted(eclass_vars)])
  print('    -- %s\n%s' %
        (eclass,
         textwrap.fill(
             var_list, 80, initial_indent='    ', subsequent_indent='    ')))


def process_file(eclass_path):
  eclass_name = os.path.splitext(os.path.basename(eclass_path))[0]
  with open(eclass_path, 'r') as f:
    eclass_vars = set()
    eclass_inheritances = set()
    for line in f:
      line = line.strip()
      if not line:
        continue
      while line[-1] == '\\':
        line = line[:-1] + next(f).strip()
      match = VAR_RE.search(line)
      if match:
        var_name = match.group(1)
        eclass_vars.add(var_name.strip())
      else:
        match = INHERIT_RE.search(line)
        if match:
          for inheritance in re.split(r'\s+', match.string)[1:]:
            if inheritance.strip():
              eclass_inheritances.add(inheritance.strip())

    return Eclass(eclass_name, eclass_vars, eclass_inheritances)


def format_eclasses_as_haskell_map(eclasses):
  map_entries = []
  join_string = '", "'
  for value in sorted(eclasses, key=(lambda x: x.name)):
    if value.vars:
      var_list_string = f'"{join_string.join(sorted(list(value.vars)))}"'
      map_entries.append(
          textwrap.fill(
              f'("{value.name}", [{var_list_string}])',
              80,
              initial_indent='    ',
              subsequent_indent='    '))
  return_string = ',\n\n'.join(map_entries)
  return_string = f"""    Data.Map.fromList
    [
{return_string}
    ]"""
  return f"""{VAR_FILE_HEADER}\n\n
-- Last Generated: {datetime.datetime.now().strftime("%x")}

import qualified Data.Map

{PORTAGE_AUTO_VAR_NAME} =
{return_string}"""


def main(argv):
  eclasses = {}
  for path in sorted(argv, key=os.path.basename):
    if not path.endswith('.eclass'):
      continue

    new_eclass = process_file(path)
    eclasses[new_eclass.name] = new_eclass
  eclasses_list = [
      value.calculate_eclass_vars(eclasses) for key, value in eclasses.items()
  ]
  print(format_eclasses_as_haskell_map(eclasses_list))


if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))
