# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b2dc6afece198cb219b1e3f4af92f86d6f40ce4e"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "b299a1a5ae7da8f6d60cacda4066d77fbe5c86e4" "284f3602420093498b1e01984a0db1190bd55812" "478fda65401c49d9a8814ddd694a79ed5e1ba4f4" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
