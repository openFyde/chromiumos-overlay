# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="710521e036aaed2f2f47caac43179936eca51d25"
CROS_WORKON_TREE=("0c3ac991150c21db311300731f54e240235fb7ee" "bd5633cc4e3dc766907ff91480814751f574addc" "0ec18830dbf64761d26219a1cda816862ff3de93" "c200c725a537163b64b27b630cb1b67320f627a6" "7d91fe7fb77f6e0207400a49266811e49aa5a9b9" "baf2d385e5d77c52bb7d56e9c9cb94bad176114e" "6802f239919398bca82901e84d7a177dab8914f8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk attestation chaps libhwsec metrics tpm_manager trunks .gn"

PLATFORM_SUBDIR="attestation"

inherit cros-workon libchrome platform user

DESCRIPTION="Attestation service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/attestation/"

LICENSE="Apache-2.0"
KEYWORDS="*"
IUSE="test tpm tpm2"

REQUIRED_USE="tpm2? ( !tpm )"

RDEPEND="
	tpm? (
		app-crypt/trousers:=
	)
	tpm2? (
		chromeos-base/trunks:=
	)
	chromeos-base/chaps:=
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
	insinto /etc/dbus-1/system.d
	doins server/org.chromium.Attestation.conf

	insinto /etc/init
	doins server/attestationd.conf

	dosbin "${OUT}"/attestationd
	dobin "${OUT}"/attestation_client

	insinto /usr/share/policy
	newins server/attestationd-seccomp-${ARCH}.policy attestationd-seccomp.policy

	insinto /etc/dbus-1/system.d
	doins pca_agent/server/org.chromium.PcaAgent.conf
	insinto /etc/init
	doins pca_agent/server/pca_agentd.conf
	dosbin "${OUT}"/pca_agentd
	dobin "${OUT}"/pca_agent_client

	dolib.so "${OUT}"/lib/libattestation.so

	insinto /usr/include/attestation/common
	doins common/attestation_interface.h
	doins common/print_attestation_ca_proto.h
	doins common/print_interface_proto.h
	doins common/print_keystore_proto.h

	# Install the generated dbus-binding for fake pca agent.
	# It does no harm to install the header even for non-test image build.
	insinto /usr/include/attestation/pca-agent/dbus_adaptors
	doins "${OUT}"/gen/include/attestation/pca-agent/dbus_adaptors/org.chromium.PcaAgent.h

	insinto /usr/share/policy
	newins "pca_agent/server/pca_agentd-seccomp-${ARCH}.policy" pca_agentd-seccomp.policy
}

platform_pkg_test() {
	local tests=(
		attestation_testrunner
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
