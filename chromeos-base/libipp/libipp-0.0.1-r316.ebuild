# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="8b8e115cb9b76f455cbd77def6788bb976e52c3f"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "34c9e594055d662c6df4ee933273782f36d69668" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libipp .gn"

PLATFORM_SUBDIR="libipp"

inherit cros-workon platform

DESCRIPTION="The library for building and parsing IPP (Internet Printing Protocol) frames."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libipp/"

LICENSE="BSD-Google"
KEYWORDS="*"

src_install() {
	platform_src_install

	# Install fuzzer
	local fuzzer_component_id="167231"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/libipp_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
