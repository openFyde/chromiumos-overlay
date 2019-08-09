# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="df3acd8b2d8bcdc3685d17908422214823416f25"
CROS_WORKON_TREE=("2e7bbebe3598d11b16303802d48420e7cdcd27ae" "04dd50c841c09342b341c7b5b89570fdc2eb03a4" "c3c0b0f6948d2df5441409e471f0391b3281dd04" "58d8b01595e749adc9fab94edb46e674749ddbac" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk oobe_config libtpmcrypto metrics .gn"

PLATFORM_SUBDIR="oobe_config"

inherit cros-workon platform user

DESCRIPTION="Provides utilities to save and restore OOBE config."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/oobe_config/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="tpm tpm2"
REQUIRED_USE="tpm2? ( !tpm )"

RDEPEND="
	chromeos-base/libbrillo
	chromeos-base/libtpmcrypto
	chromeos-base/metrics
	dev-libs/openssl
	sys-apps/dbus
"

DEPEND="
	${RDEPEND}
	chromeos-base/power_manager-client
	chromeos-base/system_api
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
	dosbin "${OUT}"/finish_oobe_auto_config
	dosbin "${OUT}"/store_usb_oobe_config

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
