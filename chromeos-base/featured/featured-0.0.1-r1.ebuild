# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="9b1da49570855014314b317df77f6cbad761e87d"
CROS_WORKON_TREE=("6b82b37113f6969a6645e19dabaeda0cb4e502d5" "c85b6d46721b128fa00fdf50111221908c276b45" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk featured .gn"

PLATFORM_SUBDIR="featured"

inherit cros-workon platform user

DESCRIPTION="Chrome OS feature management service"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/featured/"
LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	chromeos-base/system_api:=
	sys-apps/dbus:="

src_install() {
	into /
	dosbin "${OUT}"/featured

	# Install DBus configuration.
	insinto /etc/dbus-1/system.d
	doins share/org.chromium.featured.conf

	insinto /etc/init
	doins share/featured.conf share/platform-features.json
}
