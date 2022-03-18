# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This is the DLC packs the shared libraries used by assistant in chrome.

EAPI=7

CROS_WORKON_COMMIT="e8d0ce9c4326f0e57235f1acead1fcbc1ba2d0b9"
CROS_WORKON_TREE="f365214c3256d3259d78a5f4516923c79940b702"
inherit cros-workon dlc

# No git repo for this so use empty-project.
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="platform/empty-project"

DESCRIPTION="Assistant DLC"
SRC_URI=""

# V1 of libassistant.so will be built + installed into rootfs.
DEPEND="
	chromeos-base/chromeos-chrome:=
"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}"

# libassistant.so is ~13MB == 13368808 bytes
# Account for growth:
# 20MB / 4KB block size = 5120 blocks.
DLC_PREALLOC_BLOCKS="5120"
DLC_NAME="Assistant DLC"
# Tast tests run against libassistant.so
DLC_PRELOAD=true

CHROME_DIR=/opt/google/chrome

# Don't need to unpack anything.
# Also suppresses messages related to unpacking unrecognized formats.
src_unpack() {
	:
}

src_install() {
	cp "${SYSROOT}${CHROME_DIR}/libassistant.so" "${T}/"
	into "$(dlc_add_path ${CHROME_DIR})"
	dolib.so "${T}/libassistant.so"
	dlc_src_install
}
