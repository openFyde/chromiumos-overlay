#!/bin/bash
# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

set -e
readonly script_dir="$(dirname "$(realpath -e "${BASH_SOURCE[0]}")")"

readonly chroot_arg="$1"
readonly chroot_default="${script_dir}/../../../../../../chroot"

if [[ -e ${CHROOT_VERSION_FILE} ]]; then
  echo "Script must run outside the chroot since this depends on docker"
  exit 1
fi

chroot="${chroot_arg}"
if [ -z "${chroot}" ]; then
  echo "No chroot specified, so defaulting to: ${chroot_default}"
  chroot="${chroot_default}"
fi

if [ ! -d "${chroot}" ]; then
  echo "chroot path does not exist: ${chroot}"
  exit 1
fi

build_context="${chroot}/usr/bin"

sudo docker build -f "${script_dir}/Dockerfile" "${build_context}"
