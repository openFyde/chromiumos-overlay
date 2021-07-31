# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="9b49062af90a27ae0883516880a40a3b2cfe1c32"
CROS_WORKON_TREE=("d9c21c3b0f24d480773fdba553eb9db4ee252072" "727b5a2cdf7d07c050cc575ee636711da70333a2" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk sirenia .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="sirenia/manatee-client"

inherit cros-workon platform

DESCRIPTION="Chrome OS ManaTEE D-Bus client library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/"

LICENSE="BSD-Google"
KEYWORDS="*"

BDEPEND="
	chromeos-base/chromeos-dbus-bindings
"

src_install() {
	# Install D-Bus client library.
	platform_install_dbus_client_lib "manatee"
}
