# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f548611fcf5a70b7c009bcf3417c6e4a1548c370"
CROS_WORKON_TREE=("508cf7a0cbe92241c6bbdfd45a0547005902b442" "a4adcb065605eaa1a5d114964fb34babc8b5708b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
