# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="b17948a7362ca08042e61cae800262e5fcc21bbf"
CROS_WORKON_TREE=("cb7d18568ce2d4415629ca3258abf533947134a8" "dd697e4c02ca153e93443f9b6b1172e8450c56e7" "b2c3d6190a6cdd80884e1aabc36ce7cad87863d0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk cros-disks metrics .gn"

PLATFORM_SUBDIR="cros-disks"

inherit cros-workon platform user

DESCRIPTION="Disk mounting daemon for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/cros-disks/"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="chromeless_tty fuzzer +seccomp"

COMMON_DEPEND="
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/minijail:=
	chromeos-base/session_manager-client:=
	sys-apps/rootdev:=
	sys-apps/util-linux:=
"

RDEPEND="
	${COMMON_DEPEND}
	net-fs/sshfs
	sys-fs/dosfstools
	sys-fs/exfat-utils
	sys-fs/fuse-archive
	sys-fs/fuse-exfat
	sys-fs/mount-zip
	sys-fs/ntfs3g
	sys-fs/rar2fs
	virtual/udev
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/system_api:=[fuzzer?]
"

pkg_preinst() {
	enewuser "cros-disks"
	enewgroup "cros-disks"

	enewuser "ntfs-3g"
	enewgroup "ntfs-3g"

	enewuser "fuse-archivemount"
	enewgroup "fuse-archivemount"

	enewuser "fuse-exfat"
	enewgroup "fuse-exfat"

	enewuser "fuse-fusebox"
	enewgroup "fuse-fusebox"

	enewuser "fuse-rar2fs"
	enewgroup "fuse-rar2fs"

	enewuser "fuse-zip"
	enewgroup "fuse-zip"

	enewuser "fuse-sshfs"
	enewgroup "fuse-sshfs"

	enewuser "fuse-drivefs"
	enewgroup "fuse-drivefs"

	enewuser "mkfs"
	enewgroup "mkfs"
}

src_install() {
	platform_src_install

	dobin "${OUT}"/cros-disks

	# Install USB device IDs file.
	insinto /usr/share/cros-disks
	doins usb-device-info

	# We invoke systemd-tmpfiles explicitly from the upstart config
	# since it needs to run when /sys/fs/cgroup is available.
	insinto /usr/lib/tmpfiles.d/on-demand
	doins tmpfiles.d/*.conf

	# Install seccomp policy files.
	insinto /usr/share/policy
	use seccomp && newins archivemount-seccomp-${ARCH}.policy archivemount-seccomp.policy
	use seccomp && newins mount-zip-seccomp-${ARCH}.policy mount-zip-seccomp.policy
	use seccomp && newins rar2fs-seccomp-${ARCH}.policy rar2fs-seccomp.policy
	use seccomp && newins mkfs-seccomp-${ARCH}.policy mkfs-seccomp.policy

	# Install upstart config file.
	insinto /etc/init
	doins cros-disks.conf
	# Insert the --no-session-manager flag if needed.
	if use chromeless_tty; then
		sed -i -E "s/(CROS_DISKS_OPTS=')/\1--no_session_manager /" "${D}"/etc/init/cros-disks.conf || die
	fi

	# Install D-Bus config file.
	insinto /etc/dbus-1/system.d
	doins org.chromium.CrosDisks.conf

	# Install setuid restrictions file.
	insinto /usr/share/cros/startup/process_management_policies
	doins setuid_restrictions/cros_disks_uid_allowlist.txt

	# Install powerd prefs for FUSE freeze ordering.
	insinto /usr/share/power_manager
	doins powerd_prefs/suspend_freezer_deps_*

	local fuzzers=(
		filesystem_label_fuzzer
		mount_info_fuzzer
	)

	local fuzzer
	for fuzzer in "${fuzzers[@]}"; do
		# fuzzer_component_id is unknown/unlisted
		platform_fuzzer_install "${S}"/OWNERS "${OUT}/${PN}_${fuzzer}"
	done
}

platform_pkg_test() {
	local gtest_filter_qemu_common=""
	gtest_filter_qemu_common+="DiskManagerTest.*"
	gtest_filter_qemu_common+=":ExternalMounterTest.*"
	gtest_filter_qemu_common+=":UdevDeviceTest.*"
	gtest_filter_qemu_common+=":MountInfoTest.RetrieveFromCurrentProcess"
	gtest_filter_qemu_common+=":GlibProcessTest.*"

	local gtest_filter_user_tests="-*RunAsRoot*:"
	! use x86 && ! use amd64 && gtest_filter_user_tests+="${gtest_filter_qemu_common}"

	local gtest_filter_root_tests="*RunAsRoot*-"
	! use x86 && ! use amd64 && gtest_filter_root_tests+="${gtest_filter_qemu_common}"

	platform_test "run" "${OUT}/disks_testrunner" "1" \
		"${gtest_filter_root_tests}"
	platform_test "run" "${OUT}/disks_testrunner" "0" \
		"${gtest_filter_user_tests}"
}
