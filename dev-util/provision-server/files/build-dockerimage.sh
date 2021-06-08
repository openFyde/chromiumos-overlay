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

readonly build_version_arg="$2"
readonly build_version_default="local-${USER}"
build_version="${build_version_arg}"
if [ -z "${build_version}" ]; then
  echo "No build_version specified, so defaulting to: ${build_version_default}"
  build_version="${build_version_default}"
fi

readonly tmpdir=$(mktemp -d)
trap "rm -rf ${tmpdir}" EXIT

cp "${chroot}/usr/bin/provisionserver" "${tmpdir}"

readonly build_context="${tmpdir}"

readonly registry_name="gcr.io/chromeos-bot"
readonly image_name="provision-server-image"
readonly image_tag="${registry_name}/${image_name}:${build_version}"

sudo docker build -f "${script_dir}/Dockerfile" -t "${image_tag}" "${build_context}"

# TODO(shapiroc): Authenticate and push
