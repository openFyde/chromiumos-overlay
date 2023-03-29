# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="2d89f7432d8f231a7ccf957cb4bc3bce73e9d9e4"
CROS_WORKON_TREE=("952d2f368a90cdfa98da94394d2a56079cef3597" "e96d8273dec8a25a17acd158d88ce07e859deb51" "6e2537c05135db7b7a85da8c801a540c889ce4a0" "22d5274d1e7570d1be474dd10560ef20113f4d3c" "6a6c252f53ffe4b60f24cb319e0c660293382bb4" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation metrics u2fd .gn"

PLATFORM_SUBDIR="u2fd/g2f_tools"

inherit cros-workon platform

DESCRIPTION="G2F gnubby (U2F+GCSE) development and testing tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/u2fd"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/u2fd:=
	dev-libs/hidapi:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/chromeos-ec-headers:=
	chromeos-base/protofiles:=
	chromeos-base/system_api:=
"

platform_pkg_test() {
	platform test_all
}
