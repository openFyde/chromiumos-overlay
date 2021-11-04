# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b9eca7a2bc8d57ed0722d2e7a95787fc5ac9d4e3"
CROS_WORKON_TREE=("dd5deba53d49ed330f1ab8e59f845daae76650c8" "cb4c2007d21806667fb142a9308be28163e45dd8" "84b5577206ba4849f4c3ad3e00cec4549e48eaca" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk oobe_config metrics .gn"

PLATFORM_SUBDIR="oobe_config"

inherit cros-workon platform user

DESCRIPTION="Provides utilities to save and restore OOBE config."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/oobe_config/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="tpm tpm_dynamic tpm2"
REQUIRED_USE="
	tpm_dynamic? ( tpm tpm2 )
	!tpm_dynamic? ( ?? ( tpm tpm2 ) )
"

COMMMON_DEPEND="
	>=chromeos-base/metrics-0.0.1-r3152:=
	sys-apps/dbus:=
"
RDEPEND="${COMMMON_DEPEND}"
DEPEND="
	${COMMMON_DEPEND}
	chromeos-base/power_manager-client:=
	chromeos-base/system_api:=
"

pkg_preinst() {
	enewuser "oobe_config_save"
	enewuser "oobe_config_restore"
	enewgroup "oobe_config_save"
	enewgroup "oobe_config_restore"
}

src_install() {
	dosbin "${OUT}"/rollback_prepare_save
	dosbin "${OUT}"/oobe_config_save
	dosbin "${OUT}"/oobe_config_restore
	dosbin "${OUT}"/rollback_finish_restore

	insinto /etc/dbus-1/system.d
	doins etc/dbus-1/org.chromium.OobeConfigRestore.conf

	insinto /etc/init
	doins etc/init/oobe_config_restore.conf
	doins etc/init/oobe_config_save.conf
	if use tpm2; then
		sed -i 's/and started tcsd//' \
			"${D}/etc/init/oobe_config_restore.conf" ||
			die "Can't remove upstart dependency on tcsd"

		sed -i 's/-b \/run\/tcsd//' \
			"${D}/etc/init/oobe_config_restore.conf" ||
			die "Can't remove /run/tcsd bind mount"

		sed -i 's/-b \/run\/tcsd//' \
			"${D}/etc/init/oobe_config_save.conf" ||
			die "Can't remove /run/tcsd bind mount"
	fi

	insinto /usr/share/policy
	newins seccomp_filters/oobe_config_restore-seccomp-"${ARCH}".policy \
		oobe_config_restore-seccomp.policy
	newins seccomp_filters/oobe_config_save-seccomp-"${ARCH}".policy \
		oobe_config_save-seccomp.policy
}

platform_pkg_test() {
	local tests=(
		oobe_config_test
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
