# Copyright 2015 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="1dffef3b5fa35642ed3ad2b54aa7554bf0d3ed60"
CROS_WORKON_TREE=("52639708fb7bf1a26ac114df488dc561a7ca9f3c" "6e9c26cb7b02cc6f50dd851146140fd180437202" "d1d7e3ee195fa8851737c7be406928e3da6fedd0" "f04b4cdb00eb1881eeb6c35fc3400ee726299940" "e62146994a05b9efea89b0e552f15189de3f8dfd" "44b533b9e904bd46af6027adeb73b2256de03173" "e50990262bd3c461027ede88ed133abe80d32db7" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
IUSE="cr50_onboard double_extend_pcr_issue pinweaver_csme profiling test tpm tpm_dynamic
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
