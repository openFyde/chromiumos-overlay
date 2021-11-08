# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Gcam libraries ported from google3 that are specialized for CrOS."

IUSE="march_skylake march_alderlake"

SRC_URI="gs://chromeos-localmirror/distfiles/chromeos-camera-libgcam-${PV}.tar.bz2"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="!media-libs/cros-camera-libhdr"

S="${WORKDIR}"

src_install() {
	# march USE flag check should be put before amd64, arm, and arm64.
	local march_path
	if use march_skylake; then
		march_path="x86_64-skylake"
	elif use march_alderlake; then
		march_path="x86_64-alderlake"
	elif use amd64; then
		march_path="x86_64"
	fi
	einfo "Installing binaries built with march ${march_path}"
	dolib.so "./${march_path}/libgcam_cros.so"

	# Install header files.
	insinto /usr/include/cros-camera
	doins ./*.h
}
