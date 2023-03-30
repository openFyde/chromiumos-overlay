# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="feff4408d1810c45b9e0139ff557cacc8d1974c1"
CROS_WORKON_TREE=("952d2f368a90cdfa98da94394d2a56079cef3597" "184709da3502a1f7327fdf7c561a7910a1e53cb4" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
