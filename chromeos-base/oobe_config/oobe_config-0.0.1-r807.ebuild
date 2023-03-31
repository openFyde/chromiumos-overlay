# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e364b159e56f23ece2af994214187c650908d14f"
CROS_WORKON_TREE=("04da1711dfcf3e15f8ffb8bc59e4fc277481515b" "590bf902fbbbea664a845dfe474128a6f0dc896e" "110c8104767d0b76d7aa6171b8e6c58297e9563e" "cd99f60efa1abdfe04cd4e2ebe5b092f50d3c3c5" "300a0f13961978d92feb2a2051d0606ae7407e53" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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

	local fuzzer_component_id="1031231"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/load_oobe_config_rollback_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/openssl_encryption_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
