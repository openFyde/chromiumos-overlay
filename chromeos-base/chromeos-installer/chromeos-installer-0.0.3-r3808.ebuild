# Copyright 2012 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="855248a9bd9678de4f8b2a61eba2349e10289797"
CROS_WORKON_TREE=("fd2031f3c7dd64a1ca5f16ac2b2b9e52619c561c" "f834e7e40228b458c4100226f262117a9d85cdb3" "32fd40a68dcbfac1ef5562e6d547f0b075f19b15" "6df1cbd56008025f75967252b37c51cf894558cb" "564fb269910e51bbaacfa7c076b6dd9933bfc309" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="chromeos-config common-mk installer metrics verity .gn"

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
	postinst_metrics
"

COMMON_DEPEND="
	chromeos-base/libbrillo:=
	chromeos-base/vboot_reference
	chromeos-base/verity
	manage_efi_boot_entries? ( chromeos-base/chromeos-config sys-libs/efivar )
	postinst_metrics? ( chromeos-base/metrics )
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
