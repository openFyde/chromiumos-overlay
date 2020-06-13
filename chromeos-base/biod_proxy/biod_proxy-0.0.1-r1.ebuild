# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="0e60ec7f5fed3ebb3020b588b5ce2c6d47c442af"
CROS_WORKON_TREE=("f089191a0d3d6b85e2d71b4dbba970e0fc4966e1" "3a621e40392df6807316dda63f50b97f8a7b8be6" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	chromeos-base/system_api:=
"

src_install() {
	dolib.so "${OUT}"/lib/libbiod_proxy.so
}

platform_pkg_test() {
	platform_test "run" "${OUT}/biod_proxy_test_runner"
}
