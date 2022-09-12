# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="63f953f3f1b9573ebcdbae9c1dd27322654b94a5"
CROS_WORKON_TREE=("b9732f2bc7bbc922b1abb9212879b987c70537a8" "dbb4c5a189c098e0c692a1dee66f5a6b6ef33a32" "4b39839a0685d643eeff38e9893d65cd4d9a48f8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
