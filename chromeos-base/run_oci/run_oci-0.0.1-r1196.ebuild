# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="c21dadeac761d9b5c35040dce24ee464c5abd25d"
CROS_WORKON_TREE=("20fecf8e8aefa548043f2cb501f222213c15929d" "8fc2345dd43b927e8551d9f02ed7811a271337e6" "1c1054ee18ec00349249693389d68343fb675c8e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
