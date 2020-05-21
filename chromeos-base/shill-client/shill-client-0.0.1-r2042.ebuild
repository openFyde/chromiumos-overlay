# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="00c1c357241e7f6363f556fdb0d2cf2386347008"
CROS_WORKON_TREE=("e2a3a6742f6acdc76df13145ab31b6471243d736" "a44f6dde19bb494ada8fbc8ebceadf8de23c179f" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk shill .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="shill/client"

inherit cros-workon platform

DESCRIPTION="Shill DBus client library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/shill/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="cros_host"

RDEPEND="
	!<chromeos-base/shill-0.0.2
"

BDEPEND="
	chromeos-base/chromeos-dbus-bindings:=
"

src_install() {
	# Install DBus client library.
	platform_install_dbus_client_lib "shill"
}
