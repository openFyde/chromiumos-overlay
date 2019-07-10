# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="367fc705d107932356405d25e3427bba9332979a"
CROS_WORKON_TREE=("ea6e2e1b6bec83695699ef78cec2f03321d97dd7" "bcf653201047e893a6193ed77b896b5511448fd6" "10cc0cee407334f006c7119a391061a22706021f" "7c4d96ec9e3c4947b01b5411e2f1987b3a455c16" "7751f7bb5459651b1c827e9e035faa33b278727c" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk attestation chaps tpm_manager trunks .gn"

PLATFORM_SUBDIR="attestation"

inherit cros-workon libchrome platform user

DESCRIPTION="Attestation service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/attestation/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="distributed_cryptohome test tpm tpm2"

REQUIRED_USE="tpm2? ( !tpm )"

RDEPEND="
	tpm? (
		app-crypt/trousers
	)
	tpm2? (
		chromeos-base/trunks
	)
	chromeos-base/chaps
	chromeos-base/minijail
	chromeos-base/libbrillo
	chromeos-base/tpm_manager
	"

DEPEND="
	${RDEPEND}
	chromeos-base/vboot_reference
	tpm2? (
		chromeos-base/trunks[test?]
		chromeos-base/chromeos-ec-headers
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
		if use tpm2; then
			sed -i 's/started tcsd/started tpm_managerd/' \
				"${D}/etc/init/attestationd.conf" ||
				die "Can't replace tcsd with tpm_managerd in attestationd.conf"
		fi

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
