# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="27e629bce33cf4b9adfd72353e7b1205ced202c9"
CROS_WORKON_TREE=("55939c6ae7e4e501ab2d3534ef3c746607fcc2cd" "cb92f61e7f61607bd0199575fd69efa8428a1832" "1f14ece34022286d96351e9e4992d8073e6d16ce" "e1f223c8511c80222f764c8768942936a8de01e4" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk arc/setup chromeos-config metrics .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="arc/setup"

inherit tmpfiles cros-workon cros-unibuild platform

DESCRIPTION="Set up environment to run ARC."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/setup"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="
	arc_erofs
	arc_hw_oemcrypto
	arcpp
	arcvm
	fuzzer
	houdini
	houdini64
	lvm_stateful_partition
	ndk_translation
	test"

REQUIRED_USE="|| ( arcpp arcvm )"

COMMON_DEPEND="
	arcpp? ( chromeos-base/arc-sdcard )
	chromeos-base/bootstat:=
	chromeos-base/chromeos-config-tools:=
	chromeos-base/cryptohome-client:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/patchpanel-client:=
	dev-libs/libxml2:=
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
		sys-apps/restorecon
	)
"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:=[fuzzer?]
	test? ( chromeos-base/arc-base )
"


src_install() {
	platform_src_install

	# Used for both ARCVM and ARC.
	dosbin "${OUT}"/arc-prepare-host-generated-dir
	dosbin "${OUT}"/arc-remove-data
	dosbin "${OUT}"/arc-remove-stale-data
	dolib.so "${OUT}"/lib/libarc_setup.so
	dolib.so "${OUT}"/lib/libandroidxml.so
	insinto /etc/init
	doins init/arc-prepare-host-generated-dir.conf
	doins init/arc-remove-data.conf
	doins init/arc-stale-directory-remover.conf

	dotmpfiles tmpfiles.d/*.conf

	# Some binaries are only for ARCVM
	if use arcvm; then
		# ARCVM uses this binary via virtio-fs on /usr/bin.
		# dobin instead of dosbin to install to /usr/bin.
		dobin "${OUT}"/arc-packages-xml-reader

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
		doins init/arcpp-post-login-services.conf
		doins init/arc-sdcard.conf
		doins init/arc-sdcard-mount.conf
		doins init/arc-system-mount.conf
		insinto /etc/dbus-1/system.d
		doins init/dbus-1/ArcSetupUpstart.conf

		insinto /usr/share/arc-setup
		doins init/arc-setup/config.json

		insinto /opt/google/containers/arc-art
		doins "${OUT}/dev-rootfs.squashfs"

		# container-root is where the root filesystem of the container in which
		# patchoat and dex2oat runs is mounted. dev-rootfs is mount point
		# for squashfs.
		diropts --mode=0700 --owner=root --group=root
		keepdir /opt/google/containers/arc-art/mountpoints/container-root
		keepdir /opt/google/containers/arc-art/mountpoints/dev-rootfs
		keepdir /opt/google/containers/arc-art/mountpoints/vendor
	fi

	local fuzzer_component_id="488493"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/android_binary_xml_tokenizer_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/android_xml_util_find_fingerprint_and_sdk_version_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc_setup_util_find_all_properties_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc_property_util_expand_property_contents_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/arc-setup_testrunner"
}
