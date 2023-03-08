# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="deb268cc27d0ff91f6ffa0c68491773233bcf8fc"
CROS_WORKON_TREE=("3f8a9a04e17758df936e248583cfb92fc484e24c" "d10d09686ab1f6914f340f51b4b986d032404082" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
