# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="81c85c7ca40e9e50f90d05d741f3bd385c3f8448"
CROS_WORKON_TREE=("c70c24e7eeb0c8aad6108bedde29b6984f63cd54" "ea7ad5ed0c85f47c25ed4d112344f7e251e36eb6" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
