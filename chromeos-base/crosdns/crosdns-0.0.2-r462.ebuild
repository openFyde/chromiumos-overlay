# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="eb0846c656180dd81522e64a8fecea93b2322645"
CROS_WORKON_TREE=("e3b92b04b3b4a9c54c71955052636c95b5d2edcd" "647ddefe723a3bfd0109174805c78eb019551d35" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk crosdns .gn"

PLATFORM_SUBDIR="crosdns"

inherit cros-fuzzer cros-sanitizers cros-workon platform tmpfiles user

DESCRIPTION="Local hostname modifier service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/crosdns"

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
	platform_src_install

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

	dotmpfiles tmpfiles.d/*.conf

	# fuzzer_component_id is unknown/unlisted
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/hosts_modifier_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/run_tests"
}

pkg_preinst() {
	enewuser "crosdns"
	enewgroup "crosdns"
}
