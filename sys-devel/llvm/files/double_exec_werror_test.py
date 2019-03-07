#!/usr/bin/env python2
# -*- coding: utf-8 -*-
#
# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
"""Tests for double_exec_werror."""

from __future__ import print_function

import imp
import json
import os
import shutil
import StringIO
import sys
import tempfile
import unittest

# Equivalent to `import wrapper_script_common`, but wrapper_script_common has
# no `.py` suffix. Also avoids writing `wrapper_script_commonc` files, which
# are confusing, since their name doesn't end in '.pyc'
sys.dont_write_bytecode = True
double_exec_werror = imp.load_source(
    'wrapper_script_common',
    os.path.join(os.path.dirname(__file__), 'wrapper_script_common'))


class _TempFile(object):
  """Context manager that handles temporary files.

    Creates one securely for us, hands its name to us, and then deletes it when
    either the _TempFile instance is deleted, or when we __exit__ the context
    manager.

    TemporaryFile would also work, but we want this file to be closed so it can
    be moved around/etc. so it'd be approximately just as much effort to
    maintain that as this.
  """

  def __init__(self):
    fd, file_name = tempfile.mkstemp()
    os.close(fd)
    self.name = file_name

  def __enter__(self):
    return self.name

  def _cleanup(self):
    if self.name:
      os.remove(self.name)
      self.name = None

  def __exit__(self, _type, _value, _traceback):
    self._cleanup()

  def __del__(self):
    self._cleanup()


def _ununicode(json_obj):
  """Takes a json-decoded structure, and removes unicode strings from it."""
  if isinstance(json_obj, unicode):
    return json_obj.encode('utf-8')
  if isinstance(json_obj, list):
    return [_ununicode(j) for j in json_obj]
  if isinstance(json_obj, dict):
    return {_ununicode(k): _ununicode(v) for k, v in json_obj.iteritems()}
  # Assume it's some sort of primitive type.
  return json_obj


class Test(unittest.TestCase):
  """Tests for double_exec."""

  def _collect_output_without_cwds(self, cmd, out_dir=None):
    """Collects the output of double_exec_werror with the given cmd.

      If out_dir is specified, any 'warning output' files will go to that.

      We preserve all contents of out_dir, so calling this multiple times in a
      row will build up a "concatenated" out_dir.
    """

    created_out_dir = None

    stdout = StringIO.StringIO()
    stderr = StringIO.StringIO()

    # `mock` could do this just as easily, but that'd require a dependency when
    # this is run outside of the chroot.
    initial_stdout = double_exec_werror.sys.stdout
    initial_stderr = double_exec_werror.sys.stderr
    try:
      double_exec_werror.sys.stdout = stdout
      double_exec_werror.sys.stderr = stderr

      if out_dir is None:
        created_out_dir = tempfile.mkdtemp()
        out_dir = created_out_dir

      exit_code = double_exec_werror.double_build_with_wno_error(
          cmd, new_warnings_dir=out_dir)
      reports = []
      for file_name in os.listdir(out_dir):
        if not file_name.endswith('.json'):
          raise ValueError('Unexpected non-JSON file: %s' % file_name)

        with open(os.path.join(out_dir, file_name)) as f:
          reports.append(_ununicode(json.load(f)))
    finally:
      if created_out_dir:
        shutil.rmtree(created_out_dir, ignore_errors=True)

      double_exec_werror.sys.stdout = initial_stdout
      double_exec_werror.sys.stderr = initial_stderr

    for report in reports:
      self.assertEqual(report.get('cwd'), os.getcwd())
      del report['cwd']

    stdout = stdout.getvalue().strip()
    stderr = stderr.getvalue().strip()
    return exit_code, reports, stdout, stderr

  def _combined_output_without_cwds(self, cmd, out_dir=None):
    exit_code, reports, stdout, stderr = self._collect_output_without_cwds(
        cmd, out_dir)
    combined = '\n'.join(s for s in [stderr, stdout] if s)
    return exit_code, reports, combined

  def test_double_exec_runs_regular_builds_once(self):
    with _TempFile() as file_name:
      cmd = ['bash', '-c', 'echo foo >> ' + file_name]
      exit_code, out_files, stdout = self._combined_output_without_cwds(cmd)
      self.assertEqual(exit_code, 0)
      self.assertEqual(stdout, '')
      self.assertEqual(out_files, [])
      with open(file_name) as f:
        file_data = f.read().strip()
      self.assertEqual(file_data, 'foo')

  def test_double_exec_ignores_werror_on_stdout(self):
    with _TempFile() as file_name:
      exit_code, out_files, _ = self._combined_output_without_cwds(
          ['bash', '-c', 'echo -- -Werror; echo >> ' + file_name])
      self.assertEqual(exit_code, 0)
      self.assertEqual(out_files, [])
      with open(file_name) as f:
        file_data = f.read()
      self.assertEqual(file_data, '\n')

  def test_double_exec_passes_no_supplemental_args_on_first_pass(self):
    with _TempFile() as file_name:
      exit_code, out_files, stdout = self._combined_output_without_cwds(
          ['bash', '-c', 'echo $@ >> ' + file_name])
      self.assertEqual(exit_code, 0)
      self.assertEqual(stdout, '')
      self.assertEqual(out_files, [])
      with open(file_name) as f:
        file_data = f.read()
      self.assertEqual(file_data, '\n')

  def test_double_exec_runs_regular_builds_twice_with_werror(self):
    script = '\n'.join([
        'if echo "$@" | grep -q -- -Wno-error$; then',
        '   echo "wno-error"',
        'else',
        '   echo "oh no (-Werror)" >&2',
        '   exit 1',
        'fi',
    ])

    cmd = ['bash', '-c', script, '--']
    exit_code, out_files, stdout = self._combined_output_without_cwds(cmd)
    self.assertEqual(exit_code, 0)
    self.assertEqual(stdout, 'wno-error')
    self.assertEqual(out_files, [{
        'command': cmd,
        'stdout': 'oh no (-Werror)\n',
    }])

  def test_double_exec_doesnt_overwrite_existing_errors(self):
    script = '\n'.join([
        'if echo "$@" | grep -q -- -Wno-error$; then',
        '   echo "wno-error"',
        'else',
        '   echo "oh no (-Werror)" >&2',
        '   exit 1',
        'fi',
    ])

    repeats = 3
    output_dir = tempfile.mkdtemp()
    try:
      cmd = ['bash', '-c', script, '--']
      for _ in range(repeats):
        exit_code, out_files, stdout = self._combined_output_without_cwds(
            cmd, out_dir=output_dir)
        self.assertEqual(exit_code, 0)
        self.assertEqual(stdout, 'wno-error')
      self.assertEqual(
          out_files, repeats * [{
              'command': cmd,
              'stdout': 'oh no (-Werror)\n',
          }])
    finally:
      shutil.rmtree(output_dir)

  def test_werror_is_last_arg(self):
    script = '\n'.join([
        'echo "$@" >&2',
        'echo "-Werror" >&2',
        'echo "$@" | grep -q -- -Wno-error',
    ])

    cmd = ['bash', '-c', script, '--', 'foo']
    exit_code, out_files, stdout = self._combined_output_without_cwds(cmd)
    self.assertEqual(exit_code, 0)
    self.assertEqual(stdout, 'foo -Wno-error\n-Werror')
    self.assertEqual(len(out_files), 1)

  def test_original_output_is_given_when_both_fail(self):
    script = '\n'.join([
        'echo "Args: $@" >&2',
        'echo "-Werror" >&2',
        'exit 1',
    ])

    cmd = ['bash', '-c', script, '--']
    exit_code, out_files, stdout = self._combined_output_without_cwds(cmd)
    self.assertEqual(exit_code, 1)
    self.assertEqual(stdout, 'Args: \n-Werror')
    self.assertEqual(out_files, [{
        'command': cmd,
        'stdout': 'Args: \n-Werror\n',
    }])

  def test_double_exec_doesnt_double_exec_without_werror(self):
    with _TempFile() as file_name:
      script = '\n'.join([
          'echo hi >> ' + file_name,
          'if echo "$@" | grep -q -- -Wno-error$; then',
          '   echo "whee2"',
          'else',
          '   echo "whee1"',
          '   exit 1',
          'fi',
      ])

      cmd = ['bash', '-c', script, '--']
      exit_code, out_files, stdout = self._combined_output_without_cwds(cmd)
      self.assertEqual(exit_code, 1)
      self.assertEqual(stdout, 'whee1')
      self.assertEqual(out_files, [])

      with open(file_name) as f:
        file_data = f.read()
      # Check that we ran once, and only once.
      self.assertEqual(file_data, 'hi\n')

  def test_double_exec_outputs_to_the_right_place_on_double_exec(self):
    script = '\n'.join([
        'echo "hello"',
        'echo "-Werror" >&2',
        'exit 1',
    ])
    cmd = ['bash', '-c', script, '--']
    exit_code, _, stdout, stderr = self._collect_output_without_cwds(cmd)
    self.assertEqual(exit_code, 1)
    self.assertEqual(stdout, 'hello')
    self.assertEqual(stderr, '-Werror')

  def test_double_exec_outputs_to_the_right_place_on_single_exec(self):
    script = '\n'.join([
        'echo "hello"',
        'echo "world" >&2',
        'exit 1',
    ])
    cmd = ['bash', '-c', script, '--']
    exit_code, _, stdout, stderr = self._collect_output_without_cwds(cmd)
    self.assertEqual(exit_code, 1)
    self.assertEqual(stdout, 'hello')
    self.assertEqual(stderr, 'world')


if __name__ == '__main__':
  unittest.main()
