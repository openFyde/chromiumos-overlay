# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="98bffc317ef0ffd5e1ff7d09a66b7941d2bcc38c"
CROS_WORKON_TREE=("6aefce87a7cf5e4abd0f0466c5fa211f685a1193" "3fc816840d9bf21a880dcd819dcaa757fde6db1b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
