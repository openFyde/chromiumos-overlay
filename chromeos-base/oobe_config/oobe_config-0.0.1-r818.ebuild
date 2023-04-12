# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="410f3d5e668f715073f98e01459b5bcffaf65ab8"
CROS_WORKON_TREE=("8fad85aa9518e1a0f04272ae9e077c4a4036297d" "590bf902fbbbea664a845dfe474128a6f0dc896e" "be6b90ece8cba62df98f449a023b1a060f77a3b6" "7f9d4fc453e0dd5069032f56afac73fb8e903602" "c054c10084a92bffb39a6eb8e53d25cf69f675f1" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
