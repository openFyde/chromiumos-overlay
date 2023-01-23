# Copyright 2015 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3fd4925c199f19069e4b4d12aa25585bf5a4f2a4"
CROS_WORKON_TREE=("6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "5b659cec1a3e6f1f53927d44b00f9c3b8eded6cf" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
