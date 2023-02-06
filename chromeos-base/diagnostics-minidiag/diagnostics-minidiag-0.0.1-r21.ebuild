# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="21b0bfa3b9a5f3b4614f30c1ecc2f68640e90744"
CROS_WORKON_TREE=("e3b92b04b3b4a9c54c71955052636c95b5d2edcd" "08f8ec829a6b9a4b48d71434e3807a3944268f00" "36b81ce291de8cb3df69049a4a7099019a4373dd" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk diagnostics/cros_minidiag metrics .gn"

PLATFORM_SUBDIR="diagnostics/cros_minidiag"

inherit cros-fuzzer cros-sanitizers cros-workon platform

DESCRIPTION="User space utilities related to MiniDiag"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/diagnostics/cros_minidiag"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer"

DEPEND="
	>=chromeos-base/metrics-0.0.1-r3152:=
"

RDEPEND="
	sys-apps/coreboot-utils:=
"

src_configure() {
	sanitizers-setup-env
	platform_src_configure
}

src_install() {
	platform_src_install

	# Install fuzzers.
	local fuzzer_component_id="982097"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/minidiag_utils_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
