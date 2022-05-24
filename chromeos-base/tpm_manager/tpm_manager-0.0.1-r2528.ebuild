# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="215694431119443545c669523465835f772a6c9f"
CROS_WORKON_TREE=("f65480a28376b309e5661d94fbb53f8904006444" "12bbd542247aac252e1e4d9715c0cef094bb7b4c" "74305780a8891c8859d1535613a7a29e0b63fa34" "b90d0e8f789e8cfe86794cb3f36ae69967b7dc36" "d8a7d65eb2c838d88c12e4a3c3d301bfcaeec80e" "53205ab6cf3eef95bac4203fbd0ff7f7bf9c0d51" "8d334e13ee768ae278f11b187eb68d647931dea3" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
IUSE="cr50_onboard pinweaver_csme test tpm tpm_dynamic tpm_insecure_fallback
	tpm2 fuzzer os_install_service
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
	>=chromeos-base/metrics-0.0.1-r3152
	chromeos-base/minijail
	chromeos-base/libhwsec
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
	newins server/tpm_managerd-seccomp-${ARCH}.policy tpm_managerd-seccomp.policy

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
