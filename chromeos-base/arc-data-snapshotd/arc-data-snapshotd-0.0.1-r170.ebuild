# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5250ff000e4cc916c374eb226678a27a2c201bc7"
CROS_WORKON_TREE=("c48743aaa0de6c8f236911c1e6c8faf5750a0e81" "3457bfdf66939e095f6be0d2a168443372f5447c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	doins init/arc-data-snapshotd-worker.conf

	# Install DBUS configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.ArcDataSnapshotd.conf
	doins dbus/org.chromium.ArcDataSnapshotdWorker.conf
	doins dbus/ArcDataSnapshotdUpstart.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	use seccomp && newins \
		"seccomp/arc-data-snapshotd-seccomp-${ARCH}.policy" \
		arc-data-snapshotd-seccomp.policy

	dobin "${OUT}/arc-data-snapshotd"
	dobin "${OUT}/arc-data-snapshotd-worker"
}

pkg_preinst() {
	enewuser "arc-data-snapshotd"
	enewgroup "arc-data-snapshotd"
}

platform_pkg_test() {
	# Disable tests that invoke arc::data_snapshotd::CopySnapshotDirectory
	# on qemu.
	local gtest_filter_qemu=""
	gtest_filter_qemu+="-DBusAdaptorTest.TakeSnapshotAndroidDataSymLink:"
	gtest_filter_qemu+="DBusAdaptorTest.TakeSnapshotDouble:"
	gtest_filter_qemu+="DBusAdaptorTest.LoadSnapshotUnknownUser:"
	gtest_filter_qemu+="DBusAdaptorTest.LoadSnapshotSuccess:"
	gtest_filter_qemu+="DBusAdaptorTest.LoadSnapshotPreviousSuccess:"

	platform_test "run" "${OUT}/arc-data-snapshotd_test" "" "" \
		"${gtest_filter_qemu}"
	platform_test "run" "${OUT}/arc-data-snapshotd-worker_test" "" "" \
		"${gtest_filter_qemu}"
}
