# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="38040ace892c3b2a9dd45e96787dbaa1dfa117e0"
CROS_WORKON_TREE=("952d2f368a90cdfa98da94394d2a56079cef3597" "89c1899b1236d3056a89170fb3f4112cf71fd2ee" "22d5274d1e7570d1be474dd10560ef20113f4d3c" "eecea519e44c6da1d3130651e9da20c0575b3c5f" "4c9a73b6d28fdef2c43f57535eb66e383e16dd60" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk oobe_config metrics libhwsec libhwsec-foundation .gn"

PLATFORM_SUBDIR="oobe_config"

inherit cros-workon platform tmpfiles user

DESCRIPTION="Provides utilities to save and restore OOBE config."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/oobe_config/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test tpm tpm_dynamic tpm2 fuzzer"
REQUIRED_USE="
	tpm_dynamic? ( tpm tpm2 )
	!tpm_dynamic? ( ?? ( tpm tpm2 ) )
"

COMMMON_DEPEND="
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/libhwsec:=[test?]
	sys-apps/dbus:=
"
RDEPEND="
	${COMMMON_DEPEND}
"
DEPEND="
	${COMMMON_DEPEND}
	chromeos-base/power_manager-client:=
	chromeos-base/system_api:=
	fuzzer? ( dev-libs/libprotobuf-mutator:= )
"

pkg_preinst() {
	enewuser "oobe_config_save"
	enewuser "oobe_config_restore"
	enewgroup "oobe_config_save"
	enewgroup "oobe_config_restore"
}

src_install() {
	platform_src_install

	# TODO(mpolzer): delete when tcsd dependency has been removed from conf files.
	if use tpm2; then
		sed -i 's/ and started tcsd//' \
			"${D}/etc/init/oobe_config_restore.conf" ||
			die "Can't remove upstart dependency on tcsd"

		sed -i 's/-b \/run\/tcsd//' \
			"${D}/etc/init/oobe_config_restore.conf" ||
			die "Can't remove /run/tcsd bind mount"

		sed -i 's/-b \/run\/tcsd//' \
			"${D}/etc/init/oobe_config_save.conf" ||
			die "Can't remove /run/tcsd bind mount"
	fi

	local fuzzer_component_id="1031231"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/load_oobe_config_rollback_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/openssl_encryption_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
