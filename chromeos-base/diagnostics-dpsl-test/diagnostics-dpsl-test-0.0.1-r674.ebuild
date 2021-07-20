# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="c0e683d8438d284cdb3d757fd4dfe21cbaa003e3"
CROS_WORKON_TREE=("cc8ae75ea68e5c37c867b396c0540c8a109ed460" "41af3728f5a203ff3b83f91899b00bbc570c8665" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk diagnostics .gn"

PLATFORM_SUBDIR="diagnostics/dpsl"

inherit cros-workon platform

DESCRIPTION="Diagnostics DPSL test designed to be run inside VM"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/diagnostics/dpsl/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/libbrillo:=
"
RDEPEND="
	net-libs/grpc:=
	dev-libs/protobuf:=
"

src_install() {
	dobin "${OUT}/diagnostics_dpsl_test_listener"
	dobin "${OUT}/diagnostics_dpsl_test_requester"
}

platform_pkg_test() {
	local tests=(
		libdpsl_test
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
