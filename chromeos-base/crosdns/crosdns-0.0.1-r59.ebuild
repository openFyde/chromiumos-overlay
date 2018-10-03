# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="065a187e61479df3335ad07b3d9a4e1ef8974e4c"
CROS_WORKON_TREE=("690719ab5dccc27e0f2a5211cbc23d1285c47ec8" "d151aa6bc1218158ed997c71ebaad5de1fb48f85" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
SLOT="0"
KEYWORDS="*"
IUSE="+seccomp asan fuzzer"

RDEPEND="
	chromeos-base/libbrillo[asan?,fuzzer?]
	chromeos-base/minijail"

DEPEND="
	${RDEPEND}
	chromeos-base/system_api"

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
