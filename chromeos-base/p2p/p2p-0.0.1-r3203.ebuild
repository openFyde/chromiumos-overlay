# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="266f09ee24589705bec848133cc9990abb50cf5c"
CROS_WORKON_TREE=("85e4e098023fcccb8851b45c351a7045fa23f06f" "2834854981f88e2b81fefd49c590185a31f2b1f1" "412def3a1c70d403b6b02a4501e4b5c054cac292" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk metrics p2p .gn"

PLATFORM_SUBDIR="p2p"

inherit cros-debug cros-workon platform user

DESCRIPTION="Chromium OS P2P"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/p2p/"
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
	platform_fuzzer_install "${S}"/OWNERS \
			"${OUT}"/p2p_http_server_fuzzer
}
