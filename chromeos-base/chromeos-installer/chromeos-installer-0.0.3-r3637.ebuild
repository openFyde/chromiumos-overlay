# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="f5caed9f726c492522ebb6fbea6508ad9e2953bf"
CROS_WORKON_TREE=("686c1688c7cbc5f9aa4368dee421b80afd19e51a" "f13fe6260d63162b9e22bba96b94c30874378934" "01d5aabaf0fd2f9b271a2445ef944cb16aace47b" "a65107acb3c4cbbae51687d8409856f07b5dda27" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="chromeos-config common-mk installer verity .gn"

PLATFORM_SUBDIR="installer"

inherit cros-workon platform systemd

DESCRIPTION="Chrome OS Installer"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/installer/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="
	cros_embedded
	enable_slow_boot_notify
	-mtd
	pam
	systemd
	lvm_stateful_partition
	postinstall_config_efi_and_legacy
	manage_efi_boot_entries
"

COMMON_DEPEND="
	chromeos-base/libbrillo:=
	chromeos-base/vboot_reference
	chromeos-base/verity
	manage_efi_boot_entries? ( chromeos-base/chromeos-config sys-libs/efivar )
"

DEPEND="${COMMON_DEPEND}
	dev-libs/openssl:0=
"

RDEPEND="${COMMON_DEPEND}
	pam? ( app-admin/sudo )
	chromeos-base/chromeos-common-script
	!cros_embedded? ( chromeos-base/chromeos-storage-info )
	dev-libs/openssl:0=
	dev-util/shflags
	sys-apps/rootdev
	sys-apps/util-linux
	sys-apps/which
	sys-fs/e2fsprogs"

platform_pkg_test() {
	platform_test "run" "${OUT}/cros_installer_test"
}

src_install() {
	platform_src_install

	dobin "${OUT}"/cros_installer
	if use mtd ; then
		dobin "${OUT}"/nand_partition
	fi
	dosbin chromeos-* encrypted_import "${OUT}"/evwaitkey
	dosym usr/sbin/chromeos-postinst /postinst

	# Enable lvm stateful partition.
	if use lvm_stateful_partition; then
		# We are replacing expansions in a shell file, and shellcheck thinks we want
		# to expand those in this context. Ignore it.
		# shellcheck disable=SC2016
		sed -i '/DEFINE_boolean lvm_stateful "/s:\${FLAGS_FALSE}:\${FLAGS_TRUE}:' \
			"${D}/usr/sbin/chromeos-install" ||
			die "Failed to set 'lvm_stateful' in chromeos-install"
	fi

	# Install init scripts.
	if use systemd; then
		systemd_dounit init/install-completed.service
		systemd_enable_service boot-services.target install-completed.service
		systemd_dounit init/crx-import.service
		systemd_enable_service system-services.target crx-import.service
	else
		insinto /etc/init
		doins init/*.conf
	fi
	exeinto /usr/share/cros/init
	doexe init/crx-import.sh
}
