# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ed2043698a20799055259e8e98e2e245ebf68243"
CROS_WORKON_TREE=("b9732f2bc7bbc922b1abb9212879b987c70537a8" "4b8e92ad3d519afa03a87cf96438fce456fc4d67" "545f27c33d191b893b21201c4cc65655632ef2d6" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk spaced system_api .gn"

PLATFORM_SUBDIR="spaced"

inherit cros-workon platform user

DESCRIPTION="Disk space information daemon for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/spaced/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+seccomp"

DEPEND="
	chromeos-base/system_api:=
"

pkg_preinst() {
	enewuser "spaced"
	enewgroup "spaced"
}

src_install() {
	platform_install
	platform_install_dbus_client_lib

	if use seccomp; then
		local policy="seccomp/spaced-seccomp-${ARCH}.policy"
		local policy_out="${ED}/usr/share/policy/spaced-seccomp.policy.bpf"
		dodir /usr/share/policy
		compile_seccomp_policy \
			--arch-json "${SYSROOT}/build/share/constants.json" \
			--default-action trap "${policy}" "${policy_out}" \
			|| die "failed to compile seccomp policy ${policy}"
	fi
}

platform_pkg_test() {
	platform test_all
}
