# Copyright 2015 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a093eec02ee958130ad5d35088056cbe22e1368a"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "3f20ae45db07eff5dd74883293e51b24b7c7beb4" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	# Install DBus client library.
	platform_install_dbus_client_lib "power_manager"
}
