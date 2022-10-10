# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5a2fe591687507b4ee3a07da9790e627982119ce"
CROS_WORKON_TREE=("4b7854d72e018cacbb3455cf56f41cee31c70fc1" "1f3a36b5d1227bb650f903c77671be12df63c0f4" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk hiberman .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="hiberman/client"

inherit cros-workon platform

DESCRIPTION="Hibernate manager DBus client library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/hiberman/"

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
	platform_install_dbus_client_lib "hibernate"
}
