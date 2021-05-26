# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c698b4a9ed5fe4827ed0507cb8733d99cf09c03f"
CROS_WORKON_TREE=("143f88240a9dc7842a0f98b4bc12876439b8d4d9" "0c1f49f2211b7fcfdcedb3ecbdfa3f5b30bcd596" "5d77de997847c22cb783cc11cd0fab4f6fae59f0" "ac3c728704742d0682457391f0cf3d83a6d77c2f" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
KEYWORDS="*"
IUSE="tpm tpm2"
REQUIRED_USE="?? ( tpm tpm2 )"

COMMMON_DEPEND="
	chromeos-base/libtpmcrypto:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	dev-libs/openssl:0=
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
