# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4c06e5369541ecaae24aa3b0d1f394d9928d0b01"
CROS_WORKON_TREE=("5a857fb996a67f6c9781b916ba2d6076e9dcd0a6" "25019d85aeb2360afcb99e669b336246bca171f3" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	platform_src_install

	# Install DBus client library.
	platform_install_dbus_client_lib "hibernate"
}
