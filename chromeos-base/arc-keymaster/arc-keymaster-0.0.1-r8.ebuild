# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="e0f7e2825064a5acd68c82af53aa5dccb9e536b7"
CROS_WORKON_TREE=("4e679a0b9a8f37e5b43b8fb759321d5f9ff803ed" "a1c1cac491c6265cb46fd462a9972f5f231652a8" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
KEYWORDS="*"
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
