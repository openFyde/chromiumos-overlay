# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="9a3ff861a9733294d0d2f17f6a7cdd83bf449eb5"
CROS_WORKON_TREE=("0c3ac991150c21db311300731f54e240235fb7ee" "06f59d9a33e79db4264edf8eb3c8b8382e05459d" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
