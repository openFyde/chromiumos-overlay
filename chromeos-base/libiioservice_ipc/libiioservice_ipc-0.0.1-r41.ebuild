# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2a2b0046d672cce8f7f715913f96498a1b27784c"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "158259a8a3c6d49c2ae435a885180238b3a6f99b" "55c3467f43d24a0d99c27d8e9e417502a8aecede")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE=".gn iioservice common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="iioservice/libiioservice_ipc"

inherit cros-workon platform

DESCRIPTION="Chrome OS sensor HAL IPC util."

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND=""

DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_install() {
	dolib.so "${OUT}/lib/libiioservice_ipc.so"
	dolib.a "${OUT}/libiioservice_ipc_mojom.a"
}
