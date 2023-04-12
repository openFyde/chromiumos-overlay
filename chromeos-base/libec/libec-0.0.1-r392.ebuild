# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="410f3d5e668f715073f98e01459b5bcffaf65ab8"
CROS_WORKON_TREE=("48fed27d9a165cc446f05bc52f688137c4dd8d99" "8fad85aa9518e1a0f04272ae9e077c4a4036297d" "b6b60e8b2bf4c872feb68e370aee5d361daf9b7c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="biod common-mk libec .gn"

PLATFORM_SUBDIR="libec"

inherit cros-workon platform

DESCRIPTION="Embedded Controller Library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libec"

LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/chromeos-ec-headers:=
	chromeos-base/power_manager-client:=
"

RDEPEND="
	${COMMON_DEPEND}
	"

DEPEND="
	${COMMON_DEPEND}
"

src_install() {
	platform_src_install

	# Install fuzzers.
	local fuzzer_component_id="782045"
	local fuzz_targets=(
		"libec_ec_panicinfo_fuzzer"
	)
	local fuzz_target
	for fuzz_target in "${fuzz_targets[@]}"; do
		platform_fuzzer_install "${S}"/OWNERS "${OUT}"/"${fuzz_target}" \
			--comp "${fuzzer_component_id}"
	done
}

platform_pkg_test() {
	platform test_all
}
