# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="868af3bc123ec86e7ae4be12ac6a058815641942"
CROS_WORKON_TREE=("bc5d73e40a959dd5e4fdb5a6431004733015ac5d" "a1fbe98bdd2883d23d21d58564604bf7ad2f4def" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
