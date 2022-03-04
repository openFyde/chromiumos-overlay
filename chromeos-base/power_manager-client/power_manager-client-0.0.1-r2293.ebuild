# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e368128a231737069a146f3e911df222e0ebc339"
CROS_WORKON_TREE=("b50e5ebc78fa3b45d6c6ea0ede1aa648d160fb92" "00ee38717b80fc8cc73e8918ccf9766d251a6750" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk power_manager .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="power_manager/client"

inherit cros-workon platform

DESCRIPTION="Power manager DBus client library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/power_manager/"

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
	platform_install_dbus_client_lib "power_manager"
}
