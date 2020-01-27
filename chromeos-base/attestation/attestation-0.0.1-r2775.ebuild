# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0d08bbf0a6a1e5032ac03ae0d4e44c25ee82cfa1"
CROS_WORKON_TREE=("e27f1b4637c4d92b0c7b14963d2910ad6b0b631e" "128016d7736da22f5c3bf5dd1bf2d43a6bb446e3" "918e2a79c025f1b85214e1581a4098faa1386fb6" "ff56413cdc83473e5915a8ad37cd18348f77fca9" "28af022d0cd64b2b362a1fd8ce62f3ba0a5adfb2" "df79ace968ccac3eaf6f75d3b8b59ac6cbfde107" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	if use tpm2 || use distributed_cryptohome; then
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
	fi

	dolib.so "${OUT}"/lib/libattestation.so


	insinto /usr/include/attestation/client
	doins client/dbus_proxy.h
	insinto /usr/include/attestation/common
	doins common/attestation_interface.h
	doins common/print_attestation_ca_proto.h
	doins common/print_interface_proto.h
	doins common/print_keystore_proto.h
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
