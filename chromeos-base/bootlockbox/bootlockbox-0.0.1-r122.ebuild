# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="53976e946ff67846962c80391d3946561c7f14d1"
CROS_WORKON_TREE=("5b87e97f3ddb9634fb1d975839c28e49503e94f8" "b87d96116529ed1128b088517a57315e01cead66" "2779bdca56bd574df02ae3513067ddf59dfa6f37" "300a0f13961978d92feb2a2051d0606ae7407e53" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk bootlockbox libhwsec libhwsec-foundation .gn"

PLATFORM_SUBDIR="bootlockbox"

inherit cros-workon platform user

DESCRIPTION="BootLockbox service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/bootlockbox/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="fuzzer profiling systemd test tpm tpm2 tpm_dynamic"

RDEPEND="
	!<chromeos-base/cryptohome-0.0.2
	chromeos-base/bootlockbox-client:=
	chromeos-base/libhwsec:=[test?]
	chromeos-base/minijail:=
	chromeos-base/system_api:=[fuzzer?]
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/tpm_manager:=
	chromeos-base/vboot_reference:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
"

DEPEND="${RDEPEND}"

src_install() {
	platform_src_install
	# Allow specific syscalls for profiling.
	# TODO (b/242806964): Need a better approach for fixing up the seccomp policy
	# related issues (i.e. fix with a single function call)
	if use profiling; then
		sed -i "/prctl:/d" "${D}/usr/share/policy/bootlockboxd-seccomp.policy" &&
		echo -e "\n# Syscalls added for profiling case only.\nmkdir: 1\nftruncate: 1\nprctl: 1\n" >> \
		"${D}/usr/share/policy/bootlockboxd-seccomp.policy"
	fi
}

pkg_preinst() {
	enewuser "bootlockboxd"
	enewgroup "bootlockboxd"
}

platform_pkg_test() {
	platform test_all
}
