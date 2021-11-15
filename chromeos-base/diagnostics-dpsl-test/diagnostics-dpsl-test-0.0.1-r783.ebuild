# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="58b7f2b7ab832dc6de6174154e57f2a4943a229f"
CROS_WORKON_TREE=("9d87849894323414dd9afca425cb349d84a71f6b" "1a7df1bef9ab117734ff96c8bf3250882d954522" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
