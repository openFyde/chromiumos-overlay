# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="556e10fd3ebcbf74a6b88834aa31f32f4129573f"
CROS_WORKON_TREE=("ce18fba0c0aae39b3917fd9511c2a282b7fb703b" "7cd1e5dfd0c1cd79cb3c82d0597a55ca067a85d7")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk bluetooth"

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
	net-wireless/bluez"

DEPEND="${RDEPEND}
	chromeos-base/system_api"

src_install() {
	dobin "${OUT}"/btdispatch

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Bluetooth.conf

	insinto /etc/init
	doins init/upstart/btdispatch.conf

	if use seccomp; then
		# Install seccomp policy files.
		insinto /usr/share/policy
		newins "seccomp_filters/btdispatch-seccomp-${ARCH}.policy" btdispatch-seccomp.policy
	else
		# Remove seccomp flags from minijail parameters.
		sed -i '/^env seccomp_flags=/s:=.*:="":' "${ED}"/etc/init/btdispatch.conf || die
	fi
}

platform_pkg_test() {
	platform_test "run" "${OUT}/btdispatch_test"
}
