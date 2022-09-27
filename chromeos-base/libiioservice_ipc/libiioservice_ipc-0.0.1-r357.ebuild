# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1e2f09ab97baaf13b820868d68d504aeba46aad0"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "77cc0ad6e3c6963ea161d98f76bd163ea1274596" "9706471f3befaf4968d37632c5fd733272ed2ec9")
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
