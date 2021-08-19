# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="f13d8789b11ab3d0d8e4064e0dd4b6cfa510d212"
CROS_WORKON_TREE=("6b82b37113f6969a6645e19dabaeda0cb4e502d5" "d0745d1765ae4f3bcb274b0b2ea28b4d78c666f8" "c32154ddfff8e0ed06738bee2835526d9d4d339b" "26e3713c1f2916a87c54f5aa50da42d121f1a5a3" "5666fc7e1ee7a8464bf7740216c02b8d117a7461" "5acc35a68d774b89f4039d31a0efb6a5c0a3e85f" "dd44112820495ca7ea61c7861f9cfb4bde1580cd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation libtpmcrypto metrics tpm_manager trunks .gn"

PLATFORM_SUBDIR="tpm_manager"

inherit cros-workon platform user

DESCRIPTION="Daemon to manage TPM ownership."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/tpm_manager/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="pinweaver_csme test tpm tpm_dynamic tpm2 fuzzer"

REQUIRED_USE="
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
		conds=()
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
