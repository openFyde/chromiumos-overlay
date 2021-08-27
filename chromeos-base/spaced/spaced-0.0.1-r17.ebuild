# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ed5ba1aabb0359305d63c936f3ffbd53526f5310"
CROS_WORKON_TREE=("a3d79a5641e6cda7da95a9316f5d29998cc84865" "1809910be178fe83f53ee65cd997eec0ba11d4b9" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
