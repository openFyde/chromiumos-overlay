# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3a446f27a00fba076a5a42d383ae6134c333ee57"
CROS_WORKON_TREE=("52639708fb7bf1a26ac114df488dc561a7ca9f3c" "85e44b8a57c7c9fa3be1f880df58e44cc7503560" "8cf1cb9a9b3ecf72143c4d70082b8b3fdae9b64b" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libcontainer run_oci .gn"

PLATFORM_SUBDIR="run_oci"

inherit cros-workon libchrome platform

DESCRIPTION="Utility for running OCI-compatible containers"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	chromeos-base/libcontainer:=
	chromeos-base/minijail:=
	sys-apps/util-linux:=
	sys-libs/libcap:=
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_install() {
	platform_install
	# Component maps to ChromeOS>Software>ARC++>Core
	local fuzzer_component_id="488493"
	platform_fuzzer_install "${S}/OWNERS" "${OUT}/run_oci_utils_fuzzer" \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
