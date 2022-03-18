# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c8fd06eaf82cc982a2b4c287cd971b66f799e48f"
CROS_WORKON_TREE=("38a9b1daf75f7eb99a4e2bce2be48157069e9a15" "3e8ec46db7a894d8f90bf457f66dbe4e3efad0e1" "01be5723e15b095d2a9fb6db1d5f908f7d0847c0" "00138e98bf9b41e9dc9e25eaa0269bd9f27a280f" "295a2a085f108cbfe715b7c5563e2d93c65ae25c" "252d446a8eff95d46efbaa67556405056abf432a" "2acba33c99f07fa000bb44a4df3a65a8fe313bb1" "97266a4772907835fdab5d56b3ca24ed9c1c7a0e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
IUSE="generic_tpm2 test tpm tpm_dynamic tpm2"

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
