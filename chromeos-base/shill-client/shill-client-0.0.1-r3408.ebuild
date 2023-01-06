# Copyright 2015 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="eef490c5fe186416f25b3a58e3472b11c2ce13d8"
CROS_WORKON_TREE=("6a36baaa49726ee92adcded5d7a9c28124985e9a" "7c81cb356d3dbc6d93b7bdf029aacb17bd1a8eaf" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk shill .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="shill/client"

inherit cros-workon platform

DESCRIPTION="Shill DBus client library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/shill/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="cros_host"

RDEPEND="
	!<chromeos-base/shill-0.0.2
"

BDEPEND="
	chromeos-base/chromeos-dbus-bindings:=
"

src_install() {
	platform_src_install

	# Install DBus client library.
	platform_install_dbus_client_lib "shill"
}
