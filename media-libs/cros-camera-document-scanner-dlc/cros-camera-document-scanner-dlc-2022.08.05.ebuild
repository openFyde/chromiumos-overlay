# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

inherit cros-camera dlc

DESCRIPTION="Package for document scanner library as a DLC"
SRC_URI="gs://chromeos-localmirror/distfiles/chromeos-document-scanning-lib-${PV}.tar.bz2"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

S="${WORKDIR}"

# The size of the Document Scanner library is about 8.5 MB. Therefore,
# considering the future growth, we should reserve 8.5 * 130% ~= 12 MB.
DLC_PREALLOC_BLOCKS="$((12 * 256))"

DLC_PRELOAD=true

src_install() {
	# Since document_scanner.h is required for all builds, it is installed in
	# cros-camera-libfs package.

	exeinto "$(dlc_add_path /)"

	local arch_march=$(cros-camera_get_arch_march_path)
	doexe "${arch_march}/libdocumentscanner.so"
	dlc_src_install
}
