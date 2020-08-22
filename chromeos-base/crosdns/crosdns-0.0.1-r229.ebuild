# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="300292b66ec823232b046d9ee4fb24a5fc7d98fc"
CROS_WORKON_TREE=("a18be0e4067223084eb001e588d475448d48cd4c" "d4ad29b07380d249c4ea726fe900b1fef68461a7" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk crosdns .gn"

PLATFORM_SUBDIR="crosdns"

inherit cros-fuzzer cros-sanitizers cros-workon platform user

DESCRIPTION="Local hostname modifier service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/crosdns"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="+seccomp asan fuzzer"

COMMON_DEPEND="
	chromeos-base/libbrillo:=[asan?,fuzzer?]
	chromeos-base/minijail:="

RDEPEND="${COMMON_DEPEND}"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/system_api:=[fuzzer?]"

src_install() {
	# Install our binary.
	dosbin "${OUT}"/crosdns

	# Install D-Bus configuration.
	insinto /etc/dbus-1/system.d
	doins dbus_permissions/org.chromium.CrosDns.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	if use seccomp; then
		newins "init/crosdns-seccomp-${ARCH}.policy" crosdns-seccomp.policy
	fi

	# Install the init script.
	insinto /etc/init
	doins init/crosdns.conf

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/hosts_modifier_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/run_tests"
}

pkg_preinst() {
	enewuser "crosdns"
	enewgroup "crosdns"
}
