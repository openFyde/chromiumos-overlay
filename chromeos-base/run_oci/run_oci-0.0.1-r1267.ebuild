# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="2116bcb023ce61186eb5899c5641a24be51d4b48"
CROS_WORKON_TREE=("9706471f3befaf4968d37632c5fd733272ed2ec9" "85e44b8a57c7c9fa3be1f880df58e44cc7503560" "8cf1cb9a9b3ecf72143c4d70082b8b3fdae9b64b" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	platform_src_install
	# Component maps to ChromeOS>Software>ARC++>Core
	local fuzzer_component_id="488493"
	platform_fuzzer_install "${S}/OWNERS" "${OUT}/run_oci_utils_fuzzer" \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
