# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="fa08265a78a18f7ed80a9815c946578b828eb453"
CROS_WORKON_TREE=("cfe9ee34a132c6716bf20f937076d1e4b1242120" "81dfbbc1756a3b4224b447e7bf10a916d97c4f66" "75d9f73adde5a568885a0bb70db8b6d52bc3c679" "19beb6bba8b4dc12c6e4b167956a74cb8e0a92d6" "556e9c74f6749f977c12e8524396eb6d43b422b7" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libhwsec metrics trunks u2fd .gn"

PLATFORM_SUBDIR="u2fd"

inherit cros-workon platform

DESCRIPTION="G2F gnubby (U2F+GCSE) development and testing tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/u2fd"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/libhwsec:=
	dev-libs/hidapi:=
	"

RDEPEND="${COMMON_DEPEND}"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/chromeos-ec-headers:=
	chromeos-base/u2fd:=
	"

src_install() {
	dobin "${OUT}"/g2ftool
	dobin "${OUT}"/webauthntool
}

platform_pkg_test() {
	platform_test "run" "${OUT}/g2f_client_test"
}
