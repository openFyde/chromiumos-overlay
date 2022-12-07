# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ebfc497144f9b7c9575fab504ae676cf677f2fa2"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "458862745cff1f4cd5760ef83df57841e9e5a138" "284f3602420093498b1e01984a0db1190bd55812" "478fda65401c49d9a8814ddd694a79ed5e1ba4f4" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
