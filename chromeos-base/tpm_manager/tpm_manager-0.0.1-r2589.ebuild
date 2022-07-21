# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="7d99a5d4dcc2cc7e9239ec2c9054f468cd9c6480"
CROS_WORKON_TREE=("4055d34d682d2a7ff6bc4285499301674c0779ab" "1e5958d6682a671e96d7c57a852e11ca6ad9dd93" "ab00578f9729fa51e363fe7b568a2e44c5bb6bc0" "b90d0e8f789e8cfe86794cb3f36ae69967b7dc36" "cc87ad8e132ffa3b15748b9df25932d0197c29d1" "68532c536f0fde9d7f1caf7787121b16afd02199" "58121a138b5a642c2b87fcb3381d26f0dc4c5858" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation libtpmcrypto metrics tpm_manager trunks .gn"

PLATFORM_SUBDIR="tpm_manager"

inherit cros-workon platform user

DESCRIPTION="Daemon to manage TPM ownership."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/tpm_manager/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="cr50_onboard double_extend_pcr_issue pinweaver_csme test tpm tpm_dynamic
	tpm_insecure_fallback tpm2 tpm2_simulator fuzzer os_install_service
"

REQUIRED_USE="
	?? ( cr50_onboard pinweaver_csme )
	tpm_dynamic? ( tpm tpm2 )
	!tpm_dynamic? ( ?? ( tpm tpm2 ) )
"

RDEPEND="
	tpm? ( app-crypt/trousers )
	tpm2? (
		chromeos-base/trunks
	)
	tpm2_simulator? ( chromeos-base/tpm2-simulator:= )
	>=chromeos-base/metrics-0.0.1-r3152
	chromeos-base/minijail
	chromeos-base/libhwsec[test?]
	chromeos-base/libhwsec-foundation
	chromeos-base/libtpmcrypto
	chromeos-base/system_api:=[fuzzer?]
	chromeos-base/tpm_manager-client
	"

DEPEND="${RDEPEND}
	tpm2? ( chromeos-base/trunks[test?] )
	fuzzer? ( dev-libs/libprotobuf-mutator )
	"

pkg_preinst() {
	enewuser tpm_manager
	enewgroup tpm_manager
}

src_install() {
	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins server/org.chromium.TpmManager.conf

	# Install upstart config file.
	insinto /etc/init
	doins server/tpm_managerd.conf
	if use tpm_dynamic; then
		conds=("started no-tpm-checker")
		if use tpm; then
			conds+=("started tcsd")
		fi
		if use tpm2; then
			conds+=("started trunksd")
		fi
		cond=$(printf " or %s" "${conds[@]}")
		cond=${cond:4}
		sed -i "s/started tcsd/(${cond})/" \
			"${D}/etc/init/tpm_managerd.conf" ||
			die "Can't replace 'started tcsd' with '${cond}' in tpm_managerd.conf"
	elif use tpm2; then
		dep_job="trunksd"
		if use pinweaver_csme; then
			dep_job="tpm_tunneld"
		fi
		sed -i "s/started tcsd/started ${dep_job}/" \
			"${D}/etc/init/tpm_managerd.conf" ||
			die "Can't replace tcsd with ${dep_job} in tpm_managerd.conf"
	fi

	# Install the executables provided by TpmManager
	dosbin "${OUT}"/tpm_managerd
	dosbin "${OUT}"/local_data_migration

	# Install seccomp policy files.
	insinto /usr/share/policy
	newins "server/tpm_managerd-seccomp-${ARCH}.policy" tpm_managerd-seccomp.policy

	# Install fuzzer.
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/tpm_manager_service_fuzzer
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
