#!/bin/bash
# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

set -ex
readonly script_dir="$(dirname "$(realpath -e "${BASH_SOURCE[0]}")")"

build_context="${script_dir}/../../../../../../chroot/usr/bin"

sudo docker build -f "${script_dir}/Dockerfile" "${build_context}"
