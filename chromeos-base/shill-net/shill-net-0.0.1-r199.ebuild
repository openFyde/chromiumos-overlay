# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ffa34320363661fc96fa40590d82107a08535c24"
CROS_WORKON_TREE=("eaed4f3b0a8201ef3951bf1960728885ff99e772" "4dc989a2bf6dad89c3dc5248b80455b31b5982dc" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk shill .gn"

PLATFORM_SUBDIR="shill/net"

inherit cros-workon platform

DESCRIPTION="Shill networking component interface library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/shill/net"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="fuzzer +wifi"

DEPEND=""
RDEPEND="
	!<chromeos-base/shill-0.0.5
"

src_install() {
	# Install libshill-net library.
	insinto "/usr/$(get_libdir)/pkgconfig"
	local v="$(libchrome_ver)"
	./preinstall.sh "${OUT}" "${v}"
	dolib.so "${OUT}/lib/libshill-net.so"
	doins "${OUT}/lib/libshill-net.pc"

	# Install header files from libshill-net.
	insinto /usr/include/shill/net
	doins ./*.h

	local fuzzer
	for fuzzer in "${OUT}"/*_fuzzer; do
		platform_fuzzer_install "${S}"/../OWNERS "${fuzzer}"
	done
}

platform_pkg_test() {
	platform_test "run" "${OUT}/shill_net_test"
}
