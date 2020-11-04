# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4cea7110d210f443c93f6b53934fb1388ba34fb1"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "fb42b0019b3fcd84b2c1dfad949d4fc3e3bb01a5" "abc7e8d3093049ed5a5825a5630870b13d1ad4d2")
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
