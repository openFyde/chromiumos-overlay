# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3eb605cfb81c5c21432362ce042dcb080f06c9e6"
CROS_WORKON_TREE=("6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "60770331fbd3888f597df630363df5c1fe12b787" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
