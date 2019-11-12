# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="0c28a62b29e36f4d7e16365bf11b292790e8f759"
CROS_WORKON_TREE=("13277321c94a2f8ea0ff6bf7d8c246ffd349380a" "447de1a35ff031e553edc7b0350f244a6fc51e6c" "625713aa69c7be70de6b1308787e44ee46ef936c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-config modemfwd .gn"

PLATFORM_SUBDIR="modemfwd"

inherit cros-workon platform user

DESCRIPTION="Modem firmware updater daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/modemfwd"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="fuzzer"

RDEPEND="
	app-arch/xz-utils:=
	chromeos-base/chromeos-config
	chromeos-base/chromeos-config-tools
	chromeos-base/libbrillo
	dev-libs/protobuf:=
"

DEPEND="${RDEPEND}
	chromeos-base/shill-client
	chromeos-base/system_api[fuzzer?]
	fuzzer? ( dev-libs/libprotobuf-mutator )
"

src_install() {
	dobin "${OUT}/modemfwd"

	# Upstart configuration
	insinto /etc/init
	doins modemfwd.conf

	# DBus configuration
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Modemfwd.conf

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/firmware_manifest_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/firmware_manifest_v2_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/modemfw_test"
}
