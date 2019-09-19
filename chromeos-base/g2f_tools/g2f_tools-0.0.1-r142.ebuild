# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="d659b233c365b8e0b650355842e154bf958c9b29"
CROS_WORKON_TREE=("7772fb3afea858fe95c7d1c0df9cf9d493177315" "108e9694ae766f42f9e1e3e0089874ea1fb40b5f" "fda343644d509468f777bd4c0d2054daef34e9e9" "6ebe487534f122394b3843510ad5d6120c4f4107" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk metrics trunks u2fd .gn"

PLATFORM_SUBDIR="u2fd"

inherit cros-workon platform

DESCRIPTION="G2F gnubby (U2F+GCSE) development and testing tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/u2fd"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
	dev-libs/hidapi
	"

DEPEND="
	${RDEPEND}
	chromeos-base/chromeos-ec-headers
	chromeos-base/u2fd
	"

src_install() {
	dobin "${OUT}"/g2ftool
}

platform_pkg_test() {
	platform_test "run" "${OUT}/g2f_client_test"
}
