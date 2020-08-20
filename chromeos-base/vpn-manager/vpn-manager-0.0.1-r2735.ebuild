# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="eb3af34d2017adfa3c749fb4cf70264c508d328b"
CROS_WORKON_TREE=("85e4e098023fcccb8851b45c351a7045fa23f06f" "963e076a0b7311a4a5e1c14646f9a5d50c209ef7" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk vpn-manager .gn"

PLATFORM_SUBDIR="vpn-manager"

inherit cros-workon platform

DESCRIPTION="L2TP/IPsec VPN manager for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/vpn-manager/"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="
	net-dialup/ppp:=
	net-dialup/xl2tpd:=
	net-vpn/strongswan:=
"

DEPEND="${RDEPEND}"

src_install() {
	insinto /usr/include/chromeos/vpn-manager
	doins service_error.h
	dosbin "${OUT}"/l2tpipsec_vpn
	exeinto /usr/libexec/l2tpipsec_vpn
	doexe bin/pluto_updown

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/vpn_manager_service_manager_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}"/vpn_manager_test
}
