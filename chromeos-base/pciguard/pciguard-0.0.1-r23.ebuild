# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="53eb7dac34bd189fa74f7e18f11a939bdfd33a27"
CROS_WORKON_TREE=("a58d199d2c4d0e5da40bb5d453f513f5e2c97ae4" "d4a810fb2cfac7ada6351aa08f010549346bfb41" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk pciguard .gn"

PLATFORM_SUBDIR="pciguard"

inherit cros-workon platform user

DESCRIPTION="Chrome OS External PCI device security daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/pciguard/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

DEPEND="
	chromeos-base/system_api:=
"

src_install() {
	# Install the binary
	dosbin "${OUT}"/pciguard

	# Install the seccomp policy
	insinto /usr/share/policy
	newins "${S}/seccomp/pciguard-seccomp-${ARCH}.policy" pciguard-seccomp.policy

	# Install the upstart configuration files
	insinto /etc/init
	doins "${S}"/init/*.conf

	# Install the dbus configuration
	insinto /etc/dbus-1/system.d
	doins "${S}/dbus/pciguard-dbus.conf"
}

pkg_preinst() {
	enewuser pciguard
	enewgroup pciguard
	cros-workon_pkg_setup
}

platform_pkg_test() {
	platform_test "run" "${OUT}/pciguard_testrunner"
}
