# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="788cc2952abe0be18ecd45d5f0cbfc5240ad84ff"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "8e8ef335c06b4aa7b5b067b25c77854041875a40" "176028596675806a0afd96a80aff1e46e8ce08f3" "a4ee6a7b3632c28afa68a95aa67c2aff30d56334" "df143cde88af1b7e2427d71c8519156768a0ef36" "9da4303fca3d31774ff2a0ed56ad7e4beb63abc7" "e1ff5dd7dbaf0f6bd783c02d82f978618b66499f" "52a37fd272cac406117fc0fe310a1518197b40f9" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk attestation chaps libhwsec libhwsec-foundation metrics tpm_manager trunks .gn"

PLATFORM_SUBDIR="attestation"

inherit cros-workon libchrome platform user

DESCRIPTION="Attestation service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/attestation/"

LICENSE="Apache-2.0"
KEYWORDS="*"
IUSE="generic_tpm2 profiling test ti50_onboard tpm tpm_dynamic tpm2 tpm2_simulator"

REQUIRED_USE="
	tpm_dynamic? ( tpm tpm2 )
	!tpm_dynamic? ( ?? ( tpm tpm2 ) )
"

RDEPEND="
	tpm? (
		app-crypt/trousers:=
	)
	tpm2? (
		chromeos-base/trunks:=
	)
	chromeos-base/chaps:=
	chromeos-base/libhwsec:=[test?]
	chromeos-base/libhwsec-foundation:=
	chromeos-base/system_api:=[fuzzer?]
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/minijail:=
	chromeos-base/tpm_manager:=
	chromeos-base/attestation-client
	"

DEPEND="
	${RDEPEND}
	chromeos-base/vboot_reference:=
	tpm2? (
		chromeos-base/trunks:=[test?]
		chromeos-base/chromeos-ec-headers:=
	)
	"

pkg_preinst() {
	# Create user and group for attestation.
	enewuser "attestation"
	enewgroup "attestation"
	# Create group for /mnt/stateful_partition/unencrypted/preserve.
	enewgroup "preserve"
}

src_install() {
	platform_src_install

	insinto /usr/include/attestation/common
	doins common/attestation_interface.h
	doins "${OUT}"/gen/attestation/common/print_attestation_ca_proto.h
	doins "${OUT}"/gen/attestation/common/print_interface_proto.h
	doins "${OUT}"/gen/attestation/common/print_keystore_proto.h

	# Install the generated dbus-binding for fake pca agent.
	# It does no harm to install the header even for non-test image build.
	insinto /usr/include/attestation/pca-agent/dbus_adaptors
	doins "${OUT}"/gen/include/attestation/pca-agent/dbus_adaptors/org.chromium.PcaAgent.h

	# Allow specific syscalls for profiling.
	# TODO (b/242806964): Need a better approach for fixing up the seccomp policy
	# related issues (i.e. fix with a single function call)
	if use profiling; then
		echo -e "\n# Syscalls added for profiling case only.\nmkdir: 1\nftruncate: 1\n" >> \
		"${D}/usr/share/policy/attestationd-seccomp.policy"
		echo -e "\n# Syscalls added for profiling case only.\nmkdir: 1\nftruncate: 1\n" >> \
		"${D}/usr/share/policy/pca_agentd-seccomp.policy"
	fi
}

platform_pkg_test() {
	platform test_all
}
