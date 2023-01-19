# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="70311aa9463f0c5c2c85163920e84413041ef28b"
CROS_WORKON_TREE=("6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "d6819ed74e00aafbee3e7e0524f5a06282d0bebb" "69e249a9871f10d4ab3a08a2d98eb3f12eb353a8" "9b8296aa4ea81ea3560e1db0430cb15ddbe943cb" "83a5a22af215681f2f876a0c1de1caa4b709a898" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-config libcrossystem libec runtime_probe .gn"

PLATFORM_SUBDIR="runtime_probe"

inherit cros-workon cros-unibuild platform user udev

DESCRIPTION="Runtime probing on device componenets."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/runtime_probe/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="asan fuzzer"

COMMON_DEPEND="
	chromeos-base/chromeos-config-tools:=
	chromeos-base/cros-camera-libs:=
	chromeos-base/debugd-client:=
	chromeos-base/libcrossystem:=
	chromeos-base/libec:=
	chromeos-base/shill-client:=
	dev-libs/libpcre:=
	media-libs/minigbm:=
"

RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/ec-utils
"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:=[fuzzer?]
"

pkg_preinst() {
	# Create user and group for runtime_probe
	enewuser "runtime_probe"
	enewgroup "cros_ec-access"
	enewgroup "runtime_probe"
}

src_install() {
	platform_src_install

	# Install udev rules.
	udev_dorules udev/*.rules

	local fuzzer
	for fuzzer in "${OUT}"/*_fuzzer; do
		local fuzzer_component_id="606088"
		platform_fuzzer_install "${S}"/OWNERS "${fuzzer}" \
			--comp "${fuzzer_component_id}"
	done
}

platform_pkg_test() {
	platform test_all
}
