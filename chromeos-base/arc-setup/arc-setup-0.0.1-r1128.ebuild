# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="79bc647da203400781882be88ded17c40c03916d"
CROS_WORKON_TREE=("52a8a8b6d3bbca5e90d4761aa308a5541d52b1bb" "83d3e31e6f05c507dfd66d10557997723fa96665" "a34f2f8cdf568304be064218376ec69dec08f95e" "91bab993773ad1f95dd276029c7f11a0043d7e94" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk arc/setup chromeos-config metrics .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="arc/setup"

inherit cros-workon platform

DESCRIPTION="Set up environment to run ARC."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/setup"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="
	arcpp
	arcvm
	esdfs
	fuzzer
	generated_cros_config
	houdini
	houdini64
	ndk_translation
	unibuild"

REQUIRED_USE="|| ( arcpp arcvm )"

COMMON_DEPEND="
	esdfs? ( chromeos-base/arc-sdcard )
	chromeos-base/bootstat:=
	chromeos-base/chromeos-config-tools:=
	chromeos-base/cryptohome-client:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/patchpanel-client:=
	dev-libs/dbus-glib:=
	dev-libs/protobuf:=
	sys-libs/libselinux:=
	chromeos-base/minijail:=
"

RDEPEND="${COMMON_DEPEND}
	!<chromeos-base/arc-common-scripts-0.0.1-r131
	!<chromeos-base/arcvm-common-scripts-0.0.1-r77
	chromeos-base/patchpanel
	arcvm? ( chromeos-base/crosvm )
	arcpp? (
		chromeos-base/swap-init
		esdfs? ( sys-apps/restorecon )
	)
"

DEPEND="${COMMON_DEPEND}
	unibuild? (
		!generated_cros_config? ( chromeos-base/chromeos-config )
		generated_cros_config? ( chromeos-base/chromeos-config-bsp:= )
	)
	chromeos-base/system_api:=[fuzzer?]
"


enable_esdfs() {
	[[ -f "$1" ]] || die
	local data=$(jq ".USE_ESDFS=true" "$1")
	echo "${data}" > "$1" || die
}


src_install() {
	# Used for both ARCVM and ARC.
	dosbin "${OUT}"/arc-remove-data
	dosbin "${OUT}"/arc-remove-stale-data
	insinto /etc/init
	doins init/arc-remove-data.conf
	doins init/arc-stale-directory-remover.conf

	# Some binaries are only for ARCVM
	if use arcvm; then
		dosbin "${OUT}"/arc-apply-per-board-config
		dosbin "${OUT}"/arc-create-data
		dosbin "${OUT}"/arc-handle-upgrade
		insinto /etc/init
		doins init/arcvm-per-board-features.conf
		doins init/arc-create-data.conf
		doins init/arc-handle-upgrade.conf
		insinto /etc/dbus-1/system.d
		doins init/dbus-1/ArcVmSetupUpstart.conf
	fi

	# Other files are only for ARC.
	if use arcpp; then
		dosbin "${OUT}"/arc-setup
		insinto /etc/init
		doins init/arc-boot-continue.conf
		doins init/arc-lifetime.conf
		doins init/arc-update-restorecon-last.conf
		if use esdfs; then
			doins init/arc-sdcard.conf
			doins init/arc-sdcard-mount.conf
		fi
		doins init/arc-system-mount.conf
		insinto /etc/dbus-1/system.d
		doins init/dbus-1/ArcSetupUpstart.conf

		insinto /usr/share/arc-setup
		doins init/arc-setup/config.json

		if use esdfs; then
			enable_esdfs "${D}/usr/share/arc-setup/config.json"
		fi

		insinto /opt/google/containers/arc-art
		doins "${OUT}/dev-rootfs.squashfs"

		# container-root is where the root filesystem of the container in which
		# patchoat and dex2oat runs is mounted. dev-rootfs is mount point
		# for squashfs.
		diropts --mode=0700 --owner=root --group=root
		keepdir /opt/google/containers/arc-art/mountpoints/container-root
		keepdir /opt/google/containers/arc-art/mountpoints/dev-rootfs
		keepdir /opt/google/containers/arc-art/mountpoints/vendor

		platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc_setup_util_find_all_properties_fuzzer
		platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc_setup_util_find_fingerprint_and_sdk_version_fuzzer
	fi
}

platform_pkg_test() {
	platform_test "run" "${OUT}/arc-setup_testrunner"
}
