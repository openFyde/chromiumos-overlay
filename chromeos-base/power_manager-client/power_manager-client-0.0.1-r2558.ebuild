# Copyright 2015 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="15814459ce59dd8218bc362658f1cc69dc75dcd6"
CROS_WORKON_TREE=("5a857fb996a67f6c9781b916ba2d6076e9dcd0a6" "c9732b9ea2b8c962ba0210c6b6ad3ab12a71ebf2" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
