# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="57f858ff2e1470f6ba4caadd157c7954d993c7f1"
CROS_WORKON_TREE=("b6b10e03115551b69ba9e2502b15d5467adcd107" "53ed70a1f76fcda2794c0c9e77fffd866a81e844" "86cbea444f4155f2ac059fd59747fe5000df718d" "c414e480cf800c2f41dcc265d294a48e602e757f" "6bd2cf23bbae0e671cbd2958c784e5fd4cefbb05" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
