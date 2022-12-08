# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="275d66618708a79567dbec7b6034d5d08e291bcc"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "8e8ef335c06b4aa7b5b067b25c77854041875a40" "df143cde88af1b7e2427d71c8519156768a0ef36" "9c1a122c121b06b7f48cf0852ac656d255a739c1" "e1ff5dd7dbaf0f6bd783c02d82f978618b66499f" "52a37fd272cac406117fc0fe310a1518197b40f9" "271f7525c7b5bc6c84efca4c097f4bca7d29d34f" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
