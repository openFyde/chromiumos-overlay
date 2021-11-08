# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="75edb8ac77bb0bc7adc9c23fa2cd85791af41a68"
CROS_WORKON_TREE=("dd5deba53d49ed330f1ab8e59f845daae76650c8" "8729a4bafabef599c467b3a5b27c9ba4e294aa2e" "b0e89537ebaf40728cf77d8d4bda7e1d5a05175b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

	local fuzzer_component_id="167157"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/firmware_manifest_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/firmware_manifest_v2_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/modemfw_test"
}
