# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="8bd1042f66b665c37ca24cec2f7c0908bff56a5f"
CROS_WORKON_TREE=("ce312a57a100a69f5e2d0f8f445e1f6c7604fc95" "3cefdcbc921324681163b48a546ffcf806c9cb8a" "4005f890aa81b9c0a4d1a21eb2978712d5e42af9" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo
	chromeos-base/libcontainer
	sys-apps/util-linux
	sys-libs/libcap
"
DEPEND="${RDEPEND}"

src_install() {
	cd "${OUT}"
	dobin run_oci
}

platform_pkg_test() {
	local tests=(
		container_config_parser_test
		run_oci_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		# platform_test takes care of setting up your test environment
		platform_test "run" "${OUT}/${test_bin}"
	done
}
