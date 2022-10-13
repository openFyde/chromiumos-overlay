# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="01611cc312c9b3acec36920032731ee8be032d07"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "77cc0ad6e3c6963ea161d98f76bd163ea1274596" "284f3602420093498b1e01984a0db1190bd55812" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Remove libmems from this list.
CROS_WORKON_SUBTREE="common-mk iioservice libmems .gn"

PLATFORM_SUBDIR="iioservice/iioservice_simpleclient"

inherit cros-workon platform

DESCRIPTION="A simple client to test iioservice's mojo IPC for Chromium OS."

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libiioservice_ipc:=
	chromeos-base/libmems:=
"

DEPEND="${RDEPEND}
	chromeos-base/system_api:=
"
