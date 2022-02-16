# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="0f6e605e9ae7776f7bf84c0c617d8cdd25b44a4b"
CROS_WORKON_TREE=("adb7e529d9a6937314eaebaf0b47b08a1c154a07" "c483b9613962116a8881cefbe046d52ce851e598" "edf1040134cdf65972e6919fef514ceddce4941b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
