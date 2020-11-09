# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="596e7708bd893c1d9e817b01155ed18cf517ea6f"
CROS_WORKON_TREE=("abc7e8d3093049ed5a5825a5630870b13d1ad4d2" "0b080b59ae7895af82ac608967df3e7196c3da41" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
inherit cros-constants

CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk arc/data-snapshotd .gn"

PLATFORM_SUBDIR="arc/data-snapshotd"

inherit cros-workon platform user

DESCRIPTION="ARC data snapshotd daemon in Chrome OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/data-snapshotd"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+seccomp selinux"

RDEPEND="
	chromeos-base/bootlockbox-client:=
	chromeos-base/minijail:=
"

DEPEND="
	${RDEPEND}
	chromeos-base/system_api:=
	dev-libs/protobuf:=
	selinux? (
		sys-libs/libselinux:=
	)
"

src_install() {
	insinto /etc/init
	doins init/arc-data-snapshotd.conf

	# Install DBUS configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.ArcDataSnapshotd.conf
	doins dbus/ArcDataSnapshotdUpstart.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	use seccomp && newins \
		"seccomp/arc-data-snapshotd-seccomp-${ARCH}.policy" \
		arc-data-snapshotd-seccomp.policy

	dobin "${OUT}/arc-data-snapshotd"
}

pkg_preinst() {
	enewuser "arc-data-snapshotd"
	enewgroup "arc-data-snapshotd"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/arc-data-snapshotd_test"
}
