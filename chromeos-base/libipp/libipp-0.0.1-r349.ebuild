# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="58107a3103490d75a0952735512b5afcad0982bd"
CROS_WORKON_TREE=("ca7895485a50f354a0c396417657ff67fbbdf40f" "2c5d74ec9f4c7f25d54ead52ad89d1c5e8bf687d" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
