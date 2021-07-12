# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="4b4eb59cfb0011afa7ea6b79d6bca62acb8a0606"
CROS_WORKON_TREE=("487d577f0b2a08f0526aabf33ec63115fe32a16c" "8f8f3fd6e34931380cbc9f35bf9f2bb74d9c7c8b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	chromeos-base/session_manager-client:=
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
