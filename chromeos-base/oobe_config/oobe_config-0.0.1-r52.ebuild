# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="1d8fa17db5739128f18d883061d146c230682e7d"
CROS_WORKON_TREE=("5aa2bdc92600cbba67b37a455ef2bedb6334c1ad" "3ef3b431150fddbf3e06a8043a2bac6738bae141" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk oobe_config .gn"

PLATFORM_SUBDIR="oobe_config"

inherit cros-workon platform user

DESCRIPTION="Provides utilities to save and restore OOBE config."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/oobe_config/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo
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

	insinto /etc/init
	doins etc/init/oobe_config_restore.conf

	insinto /etc/dbus-1/system.d
	doins etc/dbus-1/org.chromium.OobeConfigRestore.conf

	# TODO(zentaro): Add secomp filters once implemented.
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
