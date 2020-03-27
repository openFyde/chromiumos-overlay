# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="421da3bf20e6e303ed83808182fd7051bffc1e0d"
CROS_WORKON_TREE=("dea48af07754556aac092c0830de0b1ab410077b" "d33af452545894a4015d3e685ef122cea924019c" "c218b19793213fbc08daad20dce926cf44766c10" "3998d7221da3cd9ad71c888a03a41160daef1513" "d8175dcdd50d3674d9ace24adae1942be49635b8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
