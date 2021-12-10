# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4481e87cb1f0478266277ee28a31db1b8e53e3b6"
CROS_WORKON_TREE=("8a107d83e7e0a12f330005e0cd66720e3d854a2e" "fbba8b0d03f68c7f8bd5f5e9c726336ff25f2d17" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
