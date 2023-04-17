# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="8753db580474608c9a317d2089ef38658e0ee7f3"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "c2ab8f1da8c58edfaccc97e5c9d141e624253199" "6350979dbc8b7aa70c83ad8a03dded778848025d")
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
	chromeos-base/system_api:=
	virtual/pkgconfig
"
