# Copyright 2015 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ba3f5f86dc2f37aaabd8a5de0f3da5df10ce4b89"
CROS_WORKON_TREE=("3f8a9a04e17758df936e248583cfb92fc484e24c" "d36d7dbf58228f2d3e0ac1b9a32f5de3dbfa081f" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk power_manager .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="power_manager/client"

inherit cros-workon platform

DESCRIPTION="Power manager DBus client library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/power_manager/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros_host"

DEPEND=""
RDEPEND=""

BDEPEND="
	chromeos-base/chromeos-dbus-bindings:=
"

src_install() {
	platform_src_install

	# Install DBus client library.
	platform_install_dbus_client_lib "power_manager"
}
