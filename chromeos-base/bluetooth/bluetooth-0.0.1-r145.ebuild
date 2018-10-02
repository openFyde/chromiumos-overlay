# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="a457cc7a65c8cd23572df023e7eaf88e3f219a4e"
CROS_WORKON_TREE=("622fb2c6022cadd56f945e7964fc2352099a0337" "82ea1c059c834ebcd629127df237a023df34ebfe" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk bluetooth .gn"

PLATFORM_SUBDIR="bluetooth"

inherit cros-workon platform

DESCRIPTION="Bluetooth service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/bluetooth"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="seccomp"

RDEPEND="
	chromeos-base/libbrillo
	chromeos-base/newblue
	net-wireless/bluez"

DEPEND="${RDEPEND}
	chromeos-base/system_api"

src_install() {
	dobin "${OUT}"/btdispatch
	dobin "${OUT}"/newblued

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Bluetooth.conf
	doins dbus/org.chromium.Newblue.conf

	insinto /etc/init
	doins init/upstart/btdispatch.conf

	if use seccomp; then
		# Install seccomp policy files.
		insinto /usr/share/policy
		newins "seccomp_filters/btdispatch-seccomp-${ARCH}.policy" btdispatch-seccomp.policy
		newins "seccomp_filters/newblued-seccomp-${ARCH}.policy" newblued-seccomp.policy
	else
		# Remove seccomp flags from minijail parameters.
		sed -i '/^env seccomp_flags=/s:=.*:="":' "${ED}"/etc/init/btdispatch.conf || die
	fi
}

platform_pkg_test() {
	platform_test "run" "${OUT}/btdispatch_test"
}
