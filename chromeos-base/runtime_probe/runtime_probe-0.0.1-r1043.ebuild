# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f596c531fff6234df9125b15e0825aa1d00c3212"
CROS_WORKON_TREE=("ca7895485a50f354a0c396417657ff67fbbdf40f" "d1531884133da981fe6414dbcd67713d10efeef7" "69e249a9871f10d4ab3a08a2d98eb3f12eb353a8" "83c3313d2db12a743a005345f4d7458e0da136e0" "8d625b0a2d7cd8634d2a0c8d3c1b4f245bfbe3fc" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
