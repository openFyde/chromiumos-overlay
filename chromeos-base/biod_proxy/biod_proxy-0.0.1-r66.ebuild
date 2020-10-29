# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="63f1b0b117d4d85f69c4bc0ab490551712ce5938"
CROS_WORKON_TREE=("3f47c000ac2656a574bb06b430a66f6783c3842a" "f6ecf9ecb7bff13875209f48719e715b7770780c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
