# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bbfc01ba074fbc54aef8e4f3fd9831e7503f5b78"
CROS_WORKON_TREE=("684de7632fb3bf23e07149db10c51780f7a80c39" "f4656655dde4f4fcbce72ae968d2b58ce909bb0c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
