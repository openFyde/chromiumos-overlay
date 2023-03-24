# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="891c6fed8bf7a16427ed099e18965e2b60c67c08"
CROS_WORKON_TREE=("3bd635af7de0989e2a32f3aaaa0f89b02cf04eed" "017dc03acde851b56f342d16fdc94a5f332ff42e" "0a40f73ed729b05b23232a164534d85d2d650e71" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
