# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="eb0cd4d70bd65aa086865e4ffbdb1ca11070f56a"
CROS_WORKON_TREE=("34e736b2ee0acc1681bb3c37947454b3459bea88" "9b41ad64b5b81aa8bca21f2349325a73cb88c724" "e0e2a108a7c4b5075717490bf1d7c0823437c045" "cdef97c315b48baee14828cbc74efb7b25646071" "4d54c19d023e6d826f52c587cf85e75c5d2db61e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libhwsec libtpmcrypto tpm_manager trunks .gn"

PLATFORM_SUBDIR="tpm_manager"

inherit cros-workon platform user

DESCRIPTION="Daemon to manage TPM ownership."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/tpm_manager/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="distributed_cryptohome test tpm tpm2"

REQUIRED_USE="tpm2? ( !tpm )"

RDEPEND="
	!tpm2? ( app-crypt/trousers )
	tpm2? (
		chromeos-base/trunks
	)
	chromeos-base/minijail
	chromeos-base/libhwsec
	chromeos-base/libtpmcrypto
	"

DEPEND="${RDEPEND}
	tpm2? ( chromeos-base/trunks[test?] )
	"

pkg_preinst() {
	enewuser tpm_manager
	enewgroup tpm_manager
}

src_install() {
	# Install D-Bus configuration file.
	if use tpm2 || use distributed_cryptohome; then
		insinto /etc/dbus-1/system.d
		doins server/org.chromium.TpmManager.conf

		# Install upstart config file.
		insinto /etc/init
		doins server/tpm_managerd.conf
		if use tpm2; then
			sed -i 's/started tcsd/started trunksd/' \
				"${D}/etc/init/tpm_managerd.conf" ||
				die "Can't replace tcsd with trunksd in tpm_managerd.conf"
		fi

		# Install the executables provided by TpmManager
		dosbin "${OUT}"/tpm_managerd
		dosbin "${OUT}"/local_data_migration
		dobin "${OUT}"/tpm_manager_client

		# Install seccomp policy files.
		insinto /usr/share/policy
		newins server/tpm_managerd-seccomp-${ARCH}.policy tpm_managerd-seccomp.policy
	fi

	dolib.so "${OUT}"/lib/libtpm_manager.so
	dolib.a "${OUT}"/libtpm_manager_test.a


	# Install header files.
	insinto /usr/include/tpm_manager/client
	doins client/*.h
	insinto /usr/include/tpm_manager/common
	doins common/*.h
}

platform_pkg_test() {
	local tests=(
		tpm_manager_testrunner
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
