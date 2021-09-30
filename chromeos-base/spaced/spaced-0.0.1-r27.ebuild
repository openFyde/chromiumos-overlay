# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="939140c3cbc894d19e4736b01eddac3d2d72d542"
CROS_WORKON_TREE=("d897a7a44e07236268904e1df7f983871c1e1258" "be19ef76e454d6d9470a1215b476280912ece9e0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
