# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="aee62015501b5cd861221714f392415261445e90"
CROS_WORKON_TREE=("d12eaa6a060046041408b6cf0c2444c7da2bce2b" "cd73dcdc1d2b6ed5d981a92656e857f831a5b879" "df143cde88af1b7e2427d71c8519156768a0ef36" "7f496168bcd30526ff9d96c34c665b62d825d39f" "489d6d3070bfee52d650b8655ff89551453e565c" "6de49d0bc794fced41130308586470b1f89d76ab" "c920a527a6b453daa50433bd0a0b4b70e9e6b743" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk attestation libhwsec-foundation metrics tpm_manager trunks vtpm .gn"

PLATFORM_SUBDIR="vtpm"

inherit cros-workon libchrome platform user

DESCRIPTION="Virtual TPM service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/vtpm/"

LICENSE="Apache-2.0"
KEYWORDS="*"
IUSE="profiling test"

RDEPEND="
	chromeos-base/attestation:=[test?]
	chromeos-base/system_api:=
	chromeos-base/tpm_manager:=
	chromeos-base/trunks:=
	"

DEPEND="
	${RDEPEND}
	chromeos-base/attestation-client:=
	chromeos-base/trunks:=[test?]
	"

pkg_preinst() {
	# Create user and group for vtpm.
	enewuser "vtpm"
	enewgroup "vtpm"
}

src_install() {
	platform_src_install
	# Allow specific syscalls for profiling.
	# TODO (b/242806964): Need a better approach for fixing up the seccomp policy
	# related issues (i.e. fix with a single function call)
	if use profiling; then
		echo -e "\n# Syscalls added for profiling case only.\nmkdir: 1\nftruncate: 1\n" >> \
		"${D}/usr/share/policy/vtpmd-seccomp.policy"
	fi
}

platform_pkg_test() {
	platform test_all
}
