# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="36aed02287a4bdf1a99340f77bf00891c7d5a551"
CROS_WORKON_TREE=("0d8a167e372a74ff40cff24fdc7d47644590bb7e" "e24e958219386ce196b727da68485f71b3c2f59d" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk diagnostics .gn"

PLATFORM_SUBDIR="diagnostics/dpsl"

inherit cros-workon platform

DESCRIPTION="Diagnostics DPSL test designed to be run inside VM"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/diagnostics/dpsl/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/libbrillo:=
	dev-cpp/abseil-cpp:=
"
RDEPEND="
	net-libs/grpc:=
	dev-libs/protobuf:=
"

src_install() {
	platform_src_install

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
