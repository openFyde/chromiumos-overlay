# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c85c44bb01f6a318bb4a05843fcdfab452e5a8a2"
CROS_WORKON_TREE=("2e487464bf8f7df9d7bea110f9c514bd1e56bf4f" "0432d4256e813902a79dc1d57ced2350f020590a" "70f5b227fc0127f0779f4f1f15da0eb6da598cd8" "1d4aa06b821af99f85bdbd1e5d03db723214cb22" "a77eac030d6b8d943f22b938bbb94a3547feb2c9" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk arc/network arc/setup chromeos-config metrics .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="arc/setup"

inherit cros-workon platform

DESCRIPTION="Set up environment to run ARC."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/setup"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="
	arcpp
	esdfs
	fuzzer
	houdini
	houdini64
	ndk_translation
	unibuild"

REQUIRED_USE="arcpp"

COMMON_DEPEND="
	chromeos-base/bootstat:=
	chromeos-base/chromeos-config-tools:=
	chromeos-base/cryptohome-client:=
	chromeos-base/metrics:=
	dev-libs/dbus-glib:=
	dev-libs/protobuf:=
	sys-libs/libselinux:=
	chromeos-base/minijail:=
"

RDEPEND="${COMMON_DEPEND}
	chromeos-base/arc-networkd
	chromeos-base/swap-init
	esdfs? ( sys-apps/restorecon )
"

DEPEND="${COMMON_DEPEND}
	unibuild? ( chromeos-base/chromeos-config:= )
	chromeos-base/system_api:=[fuzzer?]
"


enable_esdfs() {
	[[ -f "$1" ]] || die
	local data=$(jq ".USE_ESDFS=true" "$1")
	echo "${data}" > "$1" || die
}


src_install() {
	dosbin "${OUT}"/arc-setup

	insinto /etc/init
	doins etc/arc-boot-continue.conf
	doins etc/arc-kmsg-logger.conf
	doins etc/arc-lifetime.conf
	doins etc/arc-sensor.conf
	doins etc/arc-update-restorecon-last.conf
	if use esdfs; then
		doins etc/arc-sdcard.conf
		doins etc/arc-sdcard-mount.conf
	fi
	doins etc/arc-sysctl.conf
	doins etc/arc-system-mount.conf
	doins etc/arc-ureadahead.conf
	doins etc/arc-ureadahead-trace.conf

	insinto /etc/dbus-1/system.d
	doins etc/dbus-1/ArcUpstart.conf

	insinto /usr/share/arc-setup
	doins etc/config.json

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

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc_setup_util_expand_property_contents_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc_setup_util_find_all_properties_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc_setup_util_find_fingerprint_and_sdk_version_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/arc-setup_testrunner"
}
