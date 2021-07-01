# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="c5410975d99bb0f3da043e50e5e961e0e0e6cc16"
CROS_WORKON_TREE=("791c6808b4f4f5f1c484108d66ff958d65f8f1e3" "81dfbbc1756a3b4224b447e7bf10a916d97c4f66" "5d77de997847c22cb783cc11cd0fab4f6fae59f0" "6a2c77b2943b8c30c3e6edfbbd9fafd51b89474f" "8cc20aa2c0f7a2d6b073576b3e41ac39c9be2df6" "6af760e4ccffd52a938de8e5bbe94d33bb49ee68" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libhwsec libtpmcrypto metrics tpm_manager trunks .gn"

PLATFORM_SUBDIR="tpm_manager"

inherit cros-workon platform user

DESCRIPTION="Daemon to manage TPM ownership."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/tpm_manager/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="pinweaver_csme test tpm tpm2 fuzzer"

REQUIRED_USE="tpm2? ( !tpm )"

RDEPEND="
	!tpm2? ( app-crypt/trousers )
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
	if use tpm2; then
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
