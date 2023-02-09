# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b37764f289e2f3b949d3036fd6a4934a6cb6e1a9"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "526856404a3ae4f13c639028daf8a01fc945349a" "aaaaa3f7d8b4455b36eba6a9874fca10fefb836c")
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
