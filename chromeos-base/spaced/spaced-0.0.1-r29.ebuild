# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a2803ab9f738b8137367d80e5586d09b8647e72a"
CROS_WORKON_TREE=("f74e22f5684eb7efc62098d437d9ddacaabc3e0c" "1df1cd86cc9b1097a63fda6de34de50db54a61ac" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk spaced .gn"

PLATFORM_SUBDIR="spaced"

inherit cros-workon platform user

DESCRIPTION="Disk space information daemon for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/spaced/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+seccomp"

pkg_preinst() {
	enewuser "spaced"
	enewgroup "spaced"
}

src_install() {
	# D-Bus configuration.
	insinto /etc/dbus-1/system.d
	doins dbus_bindings/org.chromium.Spaced.conf

	dolib.so "${OUT}"/lib/libspaced.so
	dosbin "${OUT}"/spaced
	dosbin "${OUT}"/spaced_cli

	insinto /etc/init
	doins init/spaced.conf

	if use seccomp; then
		local policy="seccomp/spaced-seccomp-${ARCH}.policy"
		local policy_out="${ED}/usr/share/policy/spaced-seccomp.policy.bpf"
		dodir /usr/share/policy
		compile_seccomp_policy \
			--arch-json "${SYSROOT}/build/share/constants.json" \
			--default-action trap "${policy}" "${policy_out}" \
			|| die "failed to compile seccomp policy ${policy}"
	fi

	insinto "/usr/include/spaced"
	doins ./*.h
}

platform_pkg_test() {
	platform_test "run" "${OUT}"/libspaced_unittests
}
