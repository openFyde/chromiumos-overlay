# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="eee36c5192f4eaa2959f1b532c00d6d021b32c91"
CROS_WORKON_TREE=("45463f6780972e10b5979ed201843a5dd6e93b53" "4f45b278da1ba6c3fdf6b15087c8faccc024a97b")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk diagnostics"

PLATFORM_SUBDIR="diagnostics"

inherit cros-workon platform

DESCRIPTION="Device telemetry and diagnostics for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/diagnostics"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo:=
"
DEPEND="${RDEPEND}"

src_install() {
	dobin "${OUT}/diagnosticsd"
}

platform_pkg_test() {
	local tests=(
		diagnosticsd_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
