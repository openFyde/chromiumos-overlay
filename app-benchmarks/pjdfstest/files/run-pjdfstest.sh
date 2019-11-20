#!/bin/bash
# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

set -e

shopt -s globstar

if [[ -z "$1" ]]; then
    echo "Usage: run-pjdfstest <virtio-fs tag>"
    exit 1
fi

mount -t proc proc /proc
mount -t sysfs sys /sys
mount -t tmpfs tmp /tmp
mount -t tmpfs run /run
mount -t virtiofs "$1" /mnt/stateful_partition

mkdir -p /mnt/stateful_partition/pjdfstest
cd /mnt/stateful_partition/pjdfstest

exec runtests -v /opt/pjdfstest/tests/**/*.t
