# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/keymaster .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="arc/keymaster"

inherit cros-workon platform user

DESCRIPTION="Android keymaster service in Chrome OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/keymaster"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"
IUSE="+seccomp"

RDEPEND="
	chromeos-base/libbrillo:=
	chromeos-base/minijail"

DEPEND="${RDEPEND}"

src_install() {
	insinto /etc/init
	doins init/arc-keymasterd.conf

	# Install DBUS configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus_permissions/org.chromium.ArcKeymaster.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	use seccomp && newins \
		"seccomp/arc-keymasterd-seccomp-${ARCH}.policy" \
		arc-keymasterd-seccomp.policy

	dosbin "${OUT}/arc-keymasterd"
}

pkg_preinst() {
	enewuser "arc-keymasterd"
	enewgroup "arc-keymasterd"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/arc-keymasterd_testrunner"
}
