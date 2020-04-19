# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="86bcf17f5d3fce2ea2e6f4d21ef7ca3b5a393ed2"
CROS_WORKON_TREE=("2b7b46ab1083cdcc8b17bd7f5b05ddff336b0559" "09f6be19b9dd3ce9e6c0d6bffe196f9cf98d3f25" "d9f377f127671da9704398591ad0533283d9b7e2" "d33af452545894a4015d3e685ef122cea924019c" "044881c30de6901e5b9ed9913a09f87efc6033cf" "9462d10be48849cec1d0e1e4ff751dcdb5592bde" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk attestation chaps libhwsec tpm_manager trunks .gn"

PLATFORM_SUBDIR="attestation"

inherit cros-workon libchrome platform user

DESCRIPTION="Attestation service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/attestation/"

LICENSE="Apache-2.0"
KEYWORDS="*"
IUSE="distributed_cryptohome test tpm tpm2"

REQUIRED_USE="tpm2? ( !tpm )"

RDEPEND="
	tpm? (
		app-crypt/trousers:=
	)
	tpm2? (
		chromeos-base/trunks:=
	)
	chromeos-base/chaps:=
	chromeos-base/minijail:=
	chromeos-base/tpm_manager:=
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
	sed -i 's/started tcsd/started tpm_managerd/' \
		"${D}/etc/init/attestationd.conf" ||
		die "Can't replace tcsd with tpm_managerd in attestationd.conf"

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


	insinto /usr/include/attestation/client
	doins client/dbus_proxy.h
	insinto /usr/include/attestation/common
	doins common/attestation_interface.h
	doins common/print_attestation_ca_proto.h
	doins common/print_interface_proto.h
	doins common/print_keystore_proto.h

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
