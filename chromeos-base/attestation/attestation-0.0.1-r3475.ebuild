# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="022f1abaeac591131ddd974d8f76e81d686e02f0"
CROS_WORKON_TREE=("8ff1eab586712c03641dda82a1877dfc4cd6eb72" "885357004c73ef74e7df7ae91eb1d313f4f527f4" "ec0ab4457971e62c03a44fb50a355917af5999b3" "d64b52376115cb37fae6147ff7a359fbb7d6d185" "ba414ad0d84630d5bf4ac4f82bb576f80b0d5491" "64afe36986923627fe24faf85eb12279b641bb7e" "6f7e7ec1cb76803f6498d48cab2f694ad194ae38" "ec2853f1231aae50d56781c9c63e7d4129af7b62" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
IUSE="generic_tpm2 test ti50_onboard tpm tpm_dynamic tpm2"

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
	chromeos-base/libhwsec-foundation:=
	chromeos-base/system_api:=[fuzzer?]
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/minijail:=
	chromeos-base/tpm_manager:=
	chromeos-base/attestation-client
	"

DEPEND="
	${RDEPEND}
	test? ( chromeos-base/libhwsec:= )
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
	platform_install

	insinto /usr/include/attestation/common
	doins common/attestation_interface.h
	doins "${OUT}"/gen/attestation/common/print_attestation_ca_proto.h
	doins "${OUT}"/gen/attestation/common/print_interface_proto.h
	doins "${OUT}"/gen/attestation/common/print_keystore_proto.h

	# Install the generated dbus-binding for fake pca agent.
	# It does no harm to install the header even for non-test image build.
	insinto /usr/include/attestation/pca-agent/dbus_adaptors
	doins "${OUT}"/gen/include/attestation/pca-agent/dbus_adaptors/org.chromium.PcaAgent.h
}

platform_pkg_test() {
	platform test_all
}
