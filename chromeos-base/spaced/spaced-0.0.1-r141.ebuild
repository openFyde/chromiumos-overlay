# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d7dc1ef3ac8433d0a8dd6291b6f8e6e4e0ad8dab"
CROS_WORKON_TREE=("60fa47aebd6ebfb702012849bd560717fceddcd4" "4c00bac432144c5981437d83c01395bfea270121" "4d04ecd59a0194b9798a52f47beea27b7e7e6d1d" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
