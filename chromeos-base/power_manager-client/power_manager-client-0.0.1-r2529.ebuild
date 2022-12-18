# Copyright 2015 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="58d364c0ee8a7e74bc58bb3d47c6e83f8476ff25"
CROS_WORKON_TREE=("0c3a30cd50ce72094fbd880f2d16d449139646a2" "305776e31c42be736021b1756b3748d25be245c3" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
