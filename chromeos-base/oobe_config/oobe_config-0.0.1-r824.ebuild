# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="36aed02287a4bdf1a99340f77bf00891c7d5a551"
CROS_WORKON_TREE=("0d8a167e372a74ff40cff24fdc7d47644590bb7e" "8988559c69965a3335456e1822c4fb2f9d65ccb4" "a2002e5b021a481c966a494642397c400fe65c93" "c0264ace18f901db759964a1f346331f593daaf7" "e8eaf496dd281c6b06fb6e927224b710c923ddc0" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
