# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e5dd3b000b664fc90e51413e3827e89800081376"
CROS_WORKON_TREE=("952d2f368a90cdfa98da94394d2a56079cef3597" "6a1fa01fa461baea4752c2f202ee3348a1947286" "300a0f13961978d92feb2a2051d0606ae7407e53" "22d5274d1e7570d1be474dd10560ef20113f4d3c" "73ec426125c1817fda3cb4daddbfa7325c4adeea" "0ec52c5a6c0261c38380c9ae1bdde422efcea9aa" "52b7c74c92d9fea72518839486c5ef1a3de96d62" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk attestation libhwsec-foundation metrics tpm_manager trunks vtpm .gn"

PLATFORM_SUBDIR="vtpm"

inherit cros-workon libchrome platform user

DESCRIPTION="Virtual TPM service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/vtpm/"

LICENSE="BSD-Google"
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
