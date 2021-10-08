# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="316f560f9b8490e041d8187f3cc42ba45083aa1f"
CROS_WORKON_TREE=("d897a7a44e07236268904e1df7f983871c1e1258" "5d8d388d3f43d5c380a4e95591a45c0866ecb934" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk biod .gn"

PLATFORM_SUBDIR="biod/biod_proxy"

inherit cros-workon platform

DESCRIPTION="DBus Proxy Library for Biometrics Daemon for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/biod/README.md"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND=""

DEPEND="
	chromeos-base/libbrillo:=
	chromeos-base/system_api:=
"

src_install() {
	dolib.so "${OUT}"/lib/libbiod_proxy.so
	insinto /usr/include/biod/biod_proxy/
	doins ./*.h
}

platform_pkg_test() {
	platform_test "run" "${OUT}/biod_proxy_test_runner"
}
