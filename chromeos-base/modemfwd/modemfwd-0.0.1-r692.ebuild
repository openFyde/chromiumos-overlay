# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3bedb01f0bbf8767db84c3dace0a1a126ce304b5"
CROS_WORKON_TREE=("d66915ca353c66057a35f8c816bb78c9771bfaa0" "958af77198c05e4c7d3a5b742487f27ed3d8427b" "9e9a24a469cd7973d382aaca2f705271d7f79780" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
SLOT="0/0"
KEYWORDS="*"
IUSE="fuzzer"

COMMON_DEPEND="
	app-arch/xz-utils:=
	chromeos-base/chromeos-config:=
	chromeos-base/chromeos-config-tools:=
	dev-libs/protobuf:=
	net-misc/modemmanager-next:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/shill-client:=
	chromeos-base/system_api:=[fuzzer?]
	fuzzer? ( dev-libs/libprotobuf-mutator:= )
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
