# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="f5225c8af154bb1481be192af68d8264b3969cb6"
CROS_WORKON_TREE=("bf84a23a00350764b97d4ceb2bee5c17164d7855" "108e9694ae766f42f9e1e3e0089874ea1fb40b5f" "b13f03a60c0287876790e11f78840e42341cfebd" "9ec23885eaac947bb3252d8cca9c289332f44c50" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
