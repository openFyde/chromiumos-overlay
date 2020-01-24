# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="47c7f847879bc350067d4eda4038d1151cc0abc2"
CROS_WORKON_TREE=("e27f1b4637c4d92b0c7b14963d2910ad6b0b631e" "1b0ff3afed1daa7e41fd3bed49e7c4455c99971d" "8450b9abf5dea55ab9b8b34cfca41b87e045d71f" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
