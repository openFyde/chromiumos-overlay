# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b949e831b60d43283a1c655f98c5129305df81c3"
CROS_WORKON_TREE=("65178214f5951b1a8cb86ff95dc749e846f149aa" "3d518da1ff6fb97aedeff8b1eabe2bf4a79dba30" "9edcaccb998f9f1dac82dd862beddc2491e8ab68" "73889d0041bcd8e88b0b6d54e8d40eb99eaac094" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Remove libmems from this list.
CROS_WORKON_SUBTREE="common-mk iioservice libmems mojo_service_manager .gn"

PLATFORM_SUBDIR="iioservice/iioservice_simpleclient"

inherit cros-workon platform

DESCRIPTION="A simple client to test iioservice's mojo IPC for Chromium OS."

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libiioservice_ipc:=
	chromeos-base/libmems:=
	chromeos-base/mojo_service_manager:=
"

DEPEND="${RDEPEND}
	chromeos-base/system_api:=
"
