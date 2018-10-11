#!/usr/bin/python3

# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import hashlib
import sys


def dump(blob):
    print(' '.join('%02x' % ord(x) for x in blob))

data = []
try:
    target = sys.argv[1]
    base = int(sys.argv[2], 16)
    size = int(sys.argv[3], 16)
    step = int(sys.argv[4], 16)
    for input_file in sys.argv[5:]:
        data.append(open(input_file, "rb").read())

    if target not in ('a', 'e', 'b'):
        raise ValueError
except:
    sys.exit(1)

offset = 0
while offset < size:
    if size - offset > step:
        real_step = step
    else:
        real_step = size - offset
    db_section = '%s:h:%x:%x' % (target, base + offset, real_step)
    for blob in data:
        hasher = hashlib.sha256()
        hasher.update(blob[base + offset:base + offset + real_step])
        db_section += ':\n%s' % hasher.hexdigest()
    print(db_section + '\n')
    offset += real_step
