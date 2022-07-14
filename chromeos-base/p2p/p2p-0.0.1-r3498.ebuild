# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f756d81c45f8a94d4ed6b5cc591035cd84b32564"
CROS_WORKON_TREE=("e747749e00f36b7c255da2376d5f0e9989bcd2f9" "53ab4b0d4cdfcd2203ddeb7ac3d6fe24ea82d365" "946ed9f01e0a60b34819ed95ba5f0f5618845f7e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk metrics p2p .gn"

PLATFORM_SUBDIR="p2p"

inherit cros-debug cros-workon platform user

DESCRIPTION="Chromium OS P2P"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/p2p/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND=">=chromeos-base/metrics-0.0.1-r3152:=
	dev-libs/glib:=
	net-dns/avahi-daemon:=
	net-firewall/iptables:="

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

platform_pkg_test() {
	local tests=(
		p2p-client-unittests
		p2p-server-unittests
		p2p-http-server-unittests
		p2p-common-unittests
	)

	local test_bin
	cd "${OUT}"
	for test_bin in "${tests[@]}"; do
		platform_test "run" "./${test_bin}"
	done
}

pkg_preinst() {
	# Groups are managed in the central account database.
	enewgroup p2p
	enewuser p2p
}

src_install() {
	dosbin "${OUT}"/p2p-client
	dosbin "${OUT}"/p2p-server
	dosbin "${OUT}"/p2p-http-server

	insinto /etc/init
	doins data/p2p.conf

	# Install fuzzer
	local fuzzer_component_id="908319"
	platform_fuzzer_install "${S}"/OWNERS \
			"${OUT}"/p2p_http_server_fuzzer \
			--comp "${fuzzer_component_id}"
}
