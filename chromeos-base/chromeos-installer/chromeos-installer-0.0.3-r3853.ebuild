# Copyright 2012 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="de819d77e280814d62fc07dd9ad2fc1aa8e71a11"
CROS_WORKON_TREE=("f9c7431caf7b64df59390da12d5015c7b934da90" "2f5486f5d231a8a7920e3033439b1ae644f07f5d" "07d60dea08ef5154e4c4e6e1d0d39f63bf7a089a" "22d5274d1e7570d1be474dd10560ef20113f4d3c" "564fb269910e51bbaacfa7c076b6dd9933bfc309" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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

	# Install init scripts. Non-systemd case is defined in BUILD.gn.
	if use systemd; then
		systemd_dounit init/install-completed.service
		systemd_enable_service boot-services.target install-completed.service
		systemd_dounit init/crx-import.service
		systemd_enable_service system-services.target crx-import.service
	fi
}
