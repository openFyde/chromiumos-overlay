# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5d9e35b8aed6e1af82447620cd2dfb0102e5a7b1"
CROS_WORKON_TREE=("a1485b27500f3f8a7cf4204d77b152d1c173e313" "3e8ec46db7a894d8f90bf457f66dbe4e3efad0e1" "ed68baa6c059109539c57029e9ffa406781dc5af" "fb2b8277318fb7e7eff84f5c7669a46bf60f19f5" "a68bed1ac5e870e22da1f9a736a97c48ec06fe75" "79e2a76cf364b7250de5fd651f652b8ce25cd2b2" "86c1859a13a08ce4bd10f2f943e88b64345e017a" "d98fe514ad3350c50c03c1d6864b3143aa01041d" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk attestation chaps libhwsec libhwsec-foundation metrics tpm_manager trunks .gn"

PLATFORM_SUBDIR="attestation"

inherit cros-workon libchrome platform user

DESCRIPTION="Attestation service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/attestation/"

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
